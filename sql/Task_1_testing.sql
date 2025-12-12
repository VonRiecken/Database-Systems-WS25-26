USE dbsysgr4;

-- ============================================================
-- TESTING.SQL — Validations for Canteen Ordering System
-- ============================================================

-- ============================================================
-- 1. TEST: USER TABLE CONSTRAINTS
-- ============================================================

-- 1.1 Invalid role
INSERT INTO User (name, email, password_hash, role, payment_method)
VALUES ('Invalid Role User', 'badrole@uni.edu', '$2a$10$xxx', 'Guest', 'Cash');
-- Erwartet: CHECK constraint failure (role must be Student/Employee)


-- 1.2 Duplicate email
INSERT INTO User (name, email, password_hash, role, payment_method)
VALUES ('Dup Email', 'john.j@uni.edu', '$2a$10$xxx', 'Student', 'Cash');
-- Erwartet: UNIQUE constraint error (email exists)


-- ============================================================
-- 2. TEST: MEAL TABLE CONSTRAINTS
-- ============================================================

-- 2.1 Invalid category
INSERT INTO Meal (name, category, type, price)
VALUES ('Wrong Category Meal', 'Snack', 'Vegan', 5.00);
-- Erwartet: CHECK constraint fail (category must be Breakfast/Lunch/Dinner)


-- 2.2 Invalid type
INSERT INTO Meal (name, category, type, price)
VALUES ('Wrong Type Meal', 'Lunch', 'Keto', 7.00);
-- Erwartet: CHECK constraint fail


-- 2.3 Negative Price
INSERT INTO Meal (name, category, type, price)
VALUES ('Negative Price Meal', 'Dinner', 'Normal', -3.50);
-- Erwartet: CHECK constraint fail



-- ============================================================
-- 3. TEST: INGREDIENT TABLE CONSTRAINTS
-- ============================================================

-- Negative ingredient quantity
INSERT INTO Ingredient (name, current_quantity, unit)
VALUES ('Invalid Ingredient', -10.00, 'kg');
-- Erwartet: CHECK constraint fail



-- ============================================================
-- 4. TEST: ORDER TABLE CONSTRAINTS
-- ============================================================

-- Invalid status
INSERT INTO `Order` (user_id, pickup_time, status, total_amount)
VALUES (1, '12:00:00', 'In Transit', 12.00);
-- Erwartet: CHECK constraint fail (status not allowed)



-- ============================================================
-- 5. TEST: ORDER ITEM TABLE
-- ============================================================

-- 5.1 Invalid quantity
INSERT INTO Order_Item (order_id, meal_id, quantity)
VALUES (1, 101, -2);
-- Erwartet: CHECK constraint fail

-- 5.2 Invalid meal FK
INSERT INTO Order_Item (order_id, meal_id, quantity)
VALUES (1, 999, 2);
-- Erwartet: FK constraint fail



-- ============================================================
-- 6. TEST: STORED PROCEDURE sp_place_order
-- ============================================================

-- 6.1 INVALID QUANTITY
CALL sp_place_order(1, 101, 0, '12:00:00');
-- Erwartet: Error 'Quantity must be greater than 0'

-- 6.2 INVALID MEAL ID
CALL sp_place_order(1, 999, 1, '12:00:00');
-- Erwartet: Error 'Meal does not exist'

-- 6.3 MEAL NOT AVAILABLE
UPDATE Meal SET is_available = FALSE WHERE meal_id = 103;
CALL sp_place_order(1, 103, 1, '12:00:00');
-- Erwartet: 'Meal is currently sold out'
UPDATE Meal SET is_available = TRUE WHERE meal_id = 103;

-- 6.4 INVALID USER
CALL sp_place_order(999, 101, 1, '12:00:00');
-- Erwartet: 'User does not exist'

-- 6.5 VALID ORDER (Student → no surcharge)
CALL sp_place_order(1, 101, 2, '13:00:00');
-- Erwartet: Order placed successfully

-- 6.6 VALID ORDER (Employee → 10% surcharge)
CALL sp_place_order(2, 102, 1, '14:00:00');
-- Erwartet: total_amount increased by 10%



-- ============================================================
-- 7. TEST: STORED FUNCTION Calculate_Order_Total
-- ============================================================

-- 7.1 Student order (no surcharge)
SELECT Calculate_Order_Total(order_id)
FROM `Order`
WHERE user_id = 1
ORDER BY order_id DESC
LIMIT 1;

-- 7.2 Employee order (10% surcharge)
SELECT Calculate_Order_Total(order_id)
FROM `Order`
WHERE user_id = 2
ORDER BY order_id DESC
LIMIT 1;



-- ============================================================
-- 8. TEST: VIEWS
-- ============================================================

-- 8.1 Monthly User Meal Report
SELECT * FROM Monthly_User_Meal_Report LIMIT 10;

-- 8.2 Monthly Revenue Summary
SELECT * FROM Monthly_Revenue_Summary;



-- ============================================================
-- 9. TEST: FOREIGN KEY CASCADE
-- ============================================================

-- Delete order → order_items should auto-delete
INSERT INTO `Order` (user_id, pickup_time, status, total_amount)
VALUES (1, '11:00:00', 'Pending', 5.00);

SET @oid = LAST_INSERT_ID();

INSERT INTO Order_Item (order_id, meal_id, quantity)
VALUES (@oid, 101, 1);

-- Delete order
DELETE FROM `Order` WHERE order_id = @oid;

-- Verify cascade
SELECT * FROM Order_Item WHERE order_id = @oid;
-- Erwartet: 0 rows returned



-- ============================================================
-- 10. TEST: FEEDBACK CONSTRAINTS
-- ============================================================

-- Rating out of range
INSERT INTO Feedback (user_id, meal_id, rating, comment)
VALUES (1, 101, 7, 'Too high rating');
-- Erwartet: CHECK constraint fail


-- Valid feedback
INSERT INTO Feedback (user_id, meal_id, rating, comment)
VALUES (1, 101, 5, 'Great meal!');


-- DONE
-- ============================================================
