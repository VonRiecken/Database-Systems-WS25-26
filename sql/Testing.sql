-- ============================================================
-- TESTING CONDITIONS — Validations for Canteen Ordering System
-- ============================================================


-- ============================================================
-- 1. TEST: USER TABLE CONSTRAINTS
-- ============================================================

-- 1.1 Invalid role
INSERT INTO User (name, email, password_hash, role, payment_token)
VALUES ('Invalid Role User', 'badrole@uni.edu', '$2a$10$xxx', 'Guest', 'UNI_ACC_0099');
-- Expected: CHECK constraint failure (role must be Student / Employee / Admin)


-- 1.2 Duplicate email
INSERT INTO User (name, email, password_hash, role, payment_token)
VALUES ('Duplicate Email', 'john.j@uni.edu', '$2a$10$xxx', 'Student', 'UNI_ACC_0100');
-- Expected: UNIQUE constraint failure (email already exists)



-- ============================================================
-- 2. TEST: MEAL TABLE CONSTRAINTS
-- ============================================================

-- 2.1 Invalid category
INSERT INTO Meal (name, category, type, price)
VALUES ('Wrong Category Meal', 'Snack', 'Vegan', 5.00);
-- Expected: CHECK constraint failure (invalid category)


-- 2.2 Invalid type
INSERT INTO Meal (name, category, type, price)
VALUES ('Wrong Type Meal', 'Lunch', 'Keto', 7.00);
-- Expected: CHECK constraint failure (invalid type)


-- 2.3 Negative price
INSERT INTO Meal (name, category, type, price)
VALUES ('Negative Price Meal', 'Dinner', 'Normal', -3.50);
-- Expected: CHECK constraint failure (price >= 0)



-- ============================================================
-- 3. TEST: INGREDIENT TABLE CONSTRAINTS
-- ============================================================

-- 3.1 Negative ingredient quantity
INSERT INTO Ingredient (name, current_quantity, unit, expiry_date)
VALUES ('Invalid Ingredient', -10.00, 'kg', DATE_ADD(CURDATE(), INTERVAL 10 DAY));
-- Expected: CHECK constraint failure (current_quantity >= 0)


-- 3.2 Force ingredient expiry
UPDATE Ingredient
SET expiry_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE ingredient_id = 1;
-- Expected: Ingredient treated as expired


-- 3.3 Verify quantity is set to zero after expiry
SELECT
    ingredient_id,
    current_quantity
FROM Ingredient
WHERE ingredient_id = 1;
-- Expected: current_quantity = 0



-- ============================================================
-- 4. TEST: ORDER TABLE CONSTRAINTS
-- ============================================================

-- 4.1 Invalid order status
INSERT INTO `Order` (user_id, pickup_time, status, total_amount)
VALUES (1, '12:00:00', 'In Transit', 12.00);
-- Expected: CHECK constraint failure (invalid status)



-- ============================================================
-- 5. TEST: ORDER_ITEM TABLE CONSTRAINTS
-- ============================================================

-- 5.1 Invalid quantity
INSERT INTO Order_Item (order_id, meal_id, quantity)
VALUES (1001, 101, -2);
-- Expected: CHECK constraint failure (quantity > 0)


-- 5.2 Invalid meal foreign key
INSERT INTO Order_Item (order_id, meal_id, quantity)
VALUES (1001, 999, 2);
-- Expected: FOREIGN KEY constraint failure



-- ============================================================
-- 6. TEST: STORED PROCEDURE sp_place_order
-- Signature:
-- sp_place_order(p_meal_id, p_user_id, p_quantity, p_pickup_time)
-- ============================================================

-- 6.1 Invalid quantity
CALL sp_place_order(101, 1, 0, '12:00:00');
-- Expected: Error 'Quantity must be greater than 0'


-- 6.2 Invalid meal ID
CALL sp_place_order(999, 1, 1, '12:00:00');
-- Expected: Error 'Meal ID does not exist'


-- 6.3 Meal not available
UPDATE Meal
SET is_available = FALSE
WHERE meal_id = 103;
-- Expected: Meal marked as unavailable

CALL sp_place_order(103, 1, 1, '12:00:00');
-- Expected: Error 'Meal is currently sold out'

UPDATE Meal
SET is_available = TRUE
WHERE meal_id = 103;
-- Expected: Meal availability restored


-- 6.4 Invalid user ID
CALL sp_place_order(101, 999, 1, '12:00:00');
-- Expected: Error 'User ID does not exist'


-- 6.5 Valid order (Student → no surcharge)
CALL sp_place_order(101, 1, 2, '13:00:00');
-- Expected: Order placed successfully, no surcharge applied


-- 6.6 Valid order (Employee → 10% surcharge)
CALL sp_place_order(102, 2, 1, '14:00:00');
-- Expected: Order placed successfully with 10% surcharge


-- 6.7 Insufficient ingredients
CALL sp_place_order(102, 1, 100, '12:00:00');
-- Expected: Error 'Insufficient ingredients for this meal'



-- ============================================================
-- 7. TEST: STORED FUNCTION Calculate_Order_Total
-- ============================================================

-- 7.1 Student order (no surcharge)
SELECT Calculate_Order_Total(order_id)
FROM `Order`
WHERE user_id = 1
ORDER BY order_id DESC
LIMIT 1;
-- Expected: Total equals sum of meal prices without surcharge


-- 7.2 Employee order (10% surcharge)
SELECT Calculate_Order_Total(order_id)
FROM `Order`
WHERE user_id = 2
ORDER BY order_id DESC
LIMIT 1;
-- Expected: Total includes 10% surcharge



-- ============================================================
-- 8. TEST: VIEWS
-- ============================================================

-- 8.1 Feedback Overview
SELECT *
FROM Feedback_Overview
LIMIT 10;
-- Expected: Joined feedback, user, and meal information


-- 8.2 Monthly Revenue Summary
SELECT *
FROM Monthly_Revenue_Summary;
-- Expected: Aggregated revenue per month for picked-up orders


-- 8.3 Order Receipt
SELECT *
FROM Order_Receipt
ORDER BY order_date DESC
LIMIT 5;
-- Expected: Detailed receipt view per order item


-- 8.4 Kitchen Docket
SELECT *
FROM Kitchen_Docket;
-- Expected: Pending and preparing orders ordered by pickup time



-- ============================================================
-- 9. TEST: FOREIGN KEY CASCADE (Order → Order_Item)
-- ============================================================

INSERT INTO `Order` (user_id, pickup_time, status, total_amount)
VALUES (1, '11:00:00', 'Pending', 5.00);
-- Expected: Order inserted successfully

SET @oid = LAST_INSERT_ID();

INSERT INTO Order_Item (order_id, meal_id, quantity)
VALUES (@oid, 101, 1);
-- Expected: Order item linked to order

DELETE FROM `Order`
WHERE order_id = @oid;
-- Expected: Order deleted

SELECT *
FROM Order_Item
WHERE order_id = @oid;
-- Expected: 0 rows returned due to ON DELETE CASCADE



-- ============================================================
-- 10. TEST: FEEDBACK CONSTRAINTS
-- ============================================================

-- 10.1 Rating out of range
INSERT INTO Feedback (user_id, meal_id, rating, comment)
VALUES (1, 101, 7, 'Too high rating');
-- Expected: CHECK constraint failure (rating must be between 1 and 5)


-- 10.2 Valid feedback
INSERT INTO Feedback (user_id, meal_id, rating, comment)
VALUES (1, 101, 5, 'Great meal!');
-- Expected: Feedback inserted successfully


-- ============================================================
-- END OF TESTING
-- ============================================================
