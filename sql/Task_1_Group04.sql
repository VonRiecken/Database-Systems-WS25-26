-- =====================================================================
-- HOCHSCHULE OFFENBURG CANTEEN ORDERING SYSTEM
-- ---------------------------------------------------------------------
-- Group 4:
--   Sean Maverick | René Wüstern | Daniel Baumstark
--   Sulthan Haja  | John Riecken
--
-- Purpose:
--   Meal ordering, billing, stock, and feedback management
-- =====================================================================

USE dbsysgr4;

-- ============================================================
-- 1. USER MANAGEMENT
-- ============================================================

CREATE TABLE IF NOT EXISTS `User` (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash CHAR(60) NOT NULL,
    role VARCHAR(10) NOT NULL,
    payment_token VARCHAR(50),
    CONSTRAINT chk_user_role
        CHECK (role IN ('Student', 'Employee', 'Admin'))
);


-- ============================================================
-- 2. MENU & INVENTORY MANAGEMENT
-- ============================================================

CREATE TABLE IF NOT EXISTS `Meal` (
    meal_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    category VARCHAR(10) NOT NULL,
    type VARCHAR(15) NOT NULL,
    price DECIMAL(5,2) NOT NULL,
    image_url VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_meal_category
        CHECK (category IN ('Breakfast', 'Lunch', 'Dinner')),
    CONSTRAINT chk_meal_type
        CHECK (type IN ('Normal', 'Vegetarian', 'Vegan')),
    CONSTRAINT chk_meal_price
        CHECK (price >= 0)
);

CREATE TABLE IF NOT EXISTS `Ingredient` (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    current_quantity DECIMAL(10,2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    expiry_date DATE NOT NULL,
    CONSTRAINT chk_ingredient_quantity
        CHECK (current_quantity >= 0)
);

CREATE TABLE IF NOT EXISTS `Recipe` (
    meal_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    quantity_needed DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (meal_id, ingredient_id),
    FOREIGN KEY (meal_id) REFERENCES Meal (meal_id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredient (ingredient_id)
);

CREATE TABLE IF NOT EXISTS `Allergen` (
    allergen_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS `Meal_Allergen` (
    meal_id INT NOT NULL,
    allergen_id INT NOT NULL,
    PRIMARY KEY (meal_id, allergen_id),
    FOREIGN KEY (meal_id) REFERENCES Meal (meal_id),
    FOREIGN KEY (allergen_id) REFERENCES Allergen (allergen_id)
);

CREATE TABLE IF NOT EXISTS `Nutritional_Info` (
    meal_id INT PRIMARY KEY,
    calories INT NOT NULL,
    fat DECIMAL(5,2),
    protein DECIMAL(5,2),
    carbs DECIMAL(5,2),
    FOREIGN KEY (meal_id) REFERENCES Meal (meal_id)
);


-- ============================================================
-- 3. ORDER MANAGEMENT
-- ============================================================

CREATE TABLE IF NOT EXISTS `Order` (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    pickup_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL,
    total_amount DECIMAL(6,2) NOT NULL,
    payment_method VARCHAR(50),
    pickup_counter VARCHAR(10),
    CONSTRAINT chk_order_status
        CHECK (status IN (
            'Pending',
            'Preparing',
            'Ready for Pickup',
            'Picked Up',
            'Cancelled'
        )),
    CONSTRAINT chk_payment_method
        CHECK (payment_method IN (
            'Cash',
            'Credit Card',
            'Student Card',
            'Other'
        )),
    FOREIGN KEY (user_id) REFERENCES User (user_id)
);

CREATE TABLE IF NOT EXISTS `Order_Item` (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    meal_id INT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT chk_item_quantity
        CHECK (quantity > 0),
    FOREIGN KEY (order_id)
        REFERENCES `Order` (order_id)
        ON DELETE CASCADE,
    FOREIGN KEY (meal_id)
        REFERENCES Meal (meal_id)
);


-- ============================================================
-- 4. FEEDBACK MANAGEMENT
-- ============================================================

CREATE TABLE IF NOT EXISTS `Feedback` (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    meal_id INT NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    feedback_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_rating_value
        CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (user_id) REFERENCES User (user_id),
    FOREIGN KEY (meal_id) REFERENCES Meal (meal_id)
);


-- ============================================================
-- 5. STORED VIEWS
-- ============================================================

-- Monthly Revenue Summary
DROP VIEW IF EXISTS Monthly_Revenue_Summary;

CREATE VIEW Monthly_Revenue_Summary AS
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(total_amount) AS total_revenue
FROM `Order`
WHERE status = 'Picked Up'
GROUP BY month;


-- Feedback Overview
DROP VIEW IF EXISTS Feedback_Overview;

CREATE VIEW Feedback_Overview AS
SELECT
    F.feedback_id,
    F.feedback_date,
    U.name AS user_name,
    U.role AS user_role,
    M.name AS meal_name,
    F.rating,
    F.comment
FROM Feedback F
JOIN User U ON F.user_id = U.user_id
JOIN Meal M ON F.meal_id = M.meal_id;


-- Order Receipt
DROP VIEW IF EXISTS Order_Receipt;

CREATE VIEW Order_Receipt AS
SELECT
    O.order_id,
    O.order_date,
    O.pickup_time,
    O.status,
    U.user_id,
    U.name AS customer_name,
    U.role AS customer_role,
    M.name AS meal_name,
    OI.quantity,
    M.price AS unit_price,
    (M.price * OI.quantity) AS line_total,
    O.total_amount AS order_total,
    O.payment_method
FROM `Order` O
JOIN User U ON O.user_id = U.user_id
JOIN Order_Item OI ON O.order_id = OI.order_id
JOIN Meal M ON OI.meal_id = M.meal_id
ORDER BY O.order_date DESC;


-- Kitchen Docket
DROP VIEW IF EXISTS Kitchen_Docket;

CREATE VIEW Kitchen_Docket AS
SELECT
    O.order_id,
    O.pickup_time,
    O.pickup_counter,
    M.name AS meal_name,
    OI.quantity,
    M.category,
    M.type
FROM `Order` O
JOIN Order_Item OI ON O.order_id = OI.order_id
JOIN Meal M ON OI.meal_id = M.meal_id
WHERE O.status IN ('Pending', 'Preparing')
ORDER BY O.pickup_time ASC;


-- ============================================================
-- 6. STORED FUNCTIONS
-- ============================================================

DELIMITER $$

DROP FUNCTION IF EXISTS Calculate_Order_Total;

CREATE FUNCTION Calculate_Order_Total (p_order_id INT)
RETURNS DECIMAL(6,2)
DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(6,2);
    DECLARE v_role VARCHAR(10);

    SELECT U.role
    INTO v_role
    FROM `Order` O
    JOIN User U ON O.user_id = U.user_id
    WHERE O.order_id = p_order_id;

    SELECT SUM(M.price * OI.quantity)
    INTO v_total
    FROM Order_Item OI
    JOIN Meal M ON OI.meal_id = M.meal_id
    WHERE OI.order_id = p_order_id;

    RETURN IF(v_role <> 'Student', v_total * 1.10, v_total);
END$$

DELIMITER $$
DROP FUNCTION IF EXISTS fn_get_dynamic_price;

CREATE FUNCTION fn_get_dynamic_price (
    p_meal_price DECIMAL(10,2),
    p_user_role VARCHAR(20)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE final_price DECIMAL(10,2);

    IF p_user_role IN ('Admin', 'Employee') THEN
        SET final_price = p_meal_price * 1.10;
    ELSE
        SET final_price = p_meal_price;
    END IF;

    RETURN final_price;
END$$

DELIMITER ;


-- ============================================================
-- 7. STORED PROCEDURES
-- ============================================================

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_get_monthly_sales;

CREATE PROCEDURE sp_get_monthly_sales ()
BEGIN
    SELECT
        DATE(order_date) AS report_date,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_revenue
    FROM `Order`
    WHERE order_date >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
    GROUP BY DATE(order_date)
    ORDER BY report_date DESC;
END$$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_weekly_sales;

CREATE PROCEDURE sp_get_weekly_sales ()
BEGIN
    SELECT
        DATE(order_date) AS report_date,
        COUNT(*) AS total_orders,
        SUM(total_amount) AS total_revenue
    FROM `Order`
    WHERE order_date >= DATE_SUB(NOW(), INTERVAL 7 DAY)
    GROUP BY DATE(order_date);
END$$

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_place_order;

CREATE PROCEDURE sp_place_order (
    IN p_meal_id INT,
    IN p_user_id INT,
    IN p_quantity INT,
    IN p_pickup_time TIME
)
BEGIN
    DECLARE v_role VARCHAR(20);
    DECLARE v_meal_price DECIMAL(5,2);
    DECLARE v_is_available BOOLEAN;
    DECLARE v_total_amount DECIMAL(6,2);
    DECLARE v_new_order_id INT;
    DECLARE v_missing_ingredient INT;

    START TRANSACTION;

    -- 1. Validate quantity
    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Quantity must be greater than 0';
    END IF;

    -- 2. Fetch meal details
    SELECT price, is_available
    INTO v_meal_price, v_is_available
    FROM Meal
    WHERE meal_id = p_meal_id
    FOR UPDATE;

    IF v_meal_price IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Meal ID does not exist';
    END IF;

    IF v_is_available = FALSE THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Meal is currently sold out';
    END IF;

    -- 3. Fetch user role
    SELECT role
    INTO v_role
    FROM User
    WHERE user_id = p_user_id
    FOR UPDATE;

    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User ID does not exist';
    END IF;

    -- 4. Check ingredient availability
    SELECT COUNT(*)
    INTO v_missing_ingredient
    FROM Recipe R
    JOIN Ingredient I ON R.ingredient_id = I.ingredient_id
    WHERE R.meal_id = p_meal_id
      AND I.current_quantity < (R.quantity_needed * p_quantity);

    IF v_missing_ingredient > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient ingredients for this meal';
    END IF;

    -- 5. Calculate total amount
    SET v_total_amount = v_meal_price * p_quantity;

    IF v_role IS NOT NULL AND v_role <> 'Student' THEN
        SET v_total_amount = v_total_amount * 1.10;
    END IF;

    -- 6. Insert order
    INSERT INTO `Order`
        (user_id, pickup_time, status, total_amount, order_date)
    VALUES
        (p_user_id, p_pickup_time, 'Pending', v_total_amount, NOW());

    SET v_new_order_id = LAST_INSERT_ID();

    -- 7. Insert order item
    INSERT INTO Order_Item
        (order_id, meal_id, quantity)
    VALUES
        (v_new_order_id, p_meal_id, p_quantity);

    COMMIT;

    -- 8. Return confirmation
    SELECT
        v_new_order_id AS OrderID,
        v_total_amount AS TotalAmount,
        'Order Placed Successfully' AS Message;
END$$

DELIMITER ;


-- ============================================================
-- 8. TRIGGERS
-- ============================================================

-- ------------------------------------------------------------
-- Trigger: Consume ingredients after an order item is inserted
-- ------------------------------------------------------------
DELIMITER $$

DROP TRIGGER IF EXISTS trg_consume_ingredients;

CREATE TRIGGER trg_consume_ingredients
AFTER INSERT ON Order_Item
FOR EACH ROW
BEGIN
    -- Reduce ingredient stock according to recipe and quantity ordered
    UPDATE Ingredient I
    JOIN Recipe R
        ON I.ingredient_id = R.ingredient_id
    SET I.current_quantity =
        I.current_quantity - (R.quantity_needed * NEW.quantity)
    WHERE R.meal_id = NEW.meal_id;
END$$


-- ------------------------------------------------------------
-- Trigger: Handle expired ingredients on INSERT
-- ------------------------------------------------------------
DELIMITER $$

DROP TRIGGER IF EXISTS trg_ingredient_expiry_insert;

CREATE TRIGGER trg_ingredient_expiry_insert
BEFORE INSERT ON Ingredient
FOR EACH ROW
BEGIN
    IF NEW.expiry_date < CURDATE() THEN
        SET NEW.current_quantity = 0;
    END IF;
END$$


-- ------------------------------------------------------------
-- Trigger: Handle expired ingredients on UPDATE
-- ------------------------------------------------------------
DELIMITER $$

DROP TRIGGER IF EXISTS trg_ingredient_expiry_update;

CREATE TRIGGER trg_ingredient_expiry_update
BEFORE UPDATE ON Ingredient
FOR EACH ROW
BEGIN
    IF NEW.expiry_date < CURDATE() THEN
        SET NEW.current_quantity = 0;
    END IF;
END$$


-- ------------------------------------------------------------
-- Trigger: Update meal availability after ingredient changes
-- ------------------------------------------------------------
DELIMITER $$

DROP TRIGGER IF EXISTS trg_update_meal_availability;

CREATE TRIGGER trg_update_meal_availability
AFTER UPDATE ON Ingredient
FOR EACH ROW
BEGIN
    -- Mark meals as unavailable if ingredient stock is insufficient
    UPDATE Meal M
    SET M.is_available = 0
    WHERE M.meal_id IN (
        SELECT R.meal_id
        FROM Recipe R
        WHERE R.ingredient_id = NEW.ingredient_id
          AND NEW.current_quantity < R.quantity_needed
    );

    -- Restore meal availability if ingredient stock is sufficient
    UPDATE Meal M
    SET M.is_available = 1
    WHERE M.meal_id IN (
        SELECT R.meal_id
        FROM Recipe R
        WHERE R.ingredient_id = NEW.ingredient_id
          AND NEW.current_quantity >= R.quantity_needed
    );
END$$

DELIMITER ;

-- ============================================================
-- 9. SAMPLE DATA (DEPENDENCY ORDER)
-- ============================================================

INSERT IGNORE INTO `User`
    (user_id, name, email, password_hash, role, payment_token)
VALUES
    (1, 'John',    'john.j@uni.edu',   '$2a$10$abcdef...hashed1', 'Student',  'UNI_ACC_0001'),    -- payment_token: University internal account (student balance system)
    (2, 'Daniel',  'daniel.s@work.edu','$2a$10$abcdef...hashed2', 'Employee', 'CC_TOKEN_A92F'),   -- payment_token:External credit card token (payment provider reference)
    (3, 'Sulthan', 'sulthan.d@uni.edu','$2a$10$abcdef...hashed3', 'Student',  'DC_TOKEN_B41C'),   -- payment_token:External debit card token
    (4, 'Sean',    'sean.l@work.edu',  '$2a$10$abcdef...hashed4', 'Employee', 'CC_TOKEN_C77E'),   -- payment_token:External credit card token
    (5, 'Rene',    'rene.w@uni.edu',   '$2a$10$abcdef...hashed5', 'Student',  'UNI_ACC_0005');    -- payment_token:University internal account



INSERT IGNORE INTO Meal (meal_id, name, description, category, type, price, image_url, is_available) VALUES
(101, 'Veggie Omelet', 'Egg omelet with vegetables', 'Breakfast', 'Vegetarian', 6.25, NULL, TRUE),
(102, 'Chicken Curry', 'Spicy curry with rice', 'Lunch', 'Normal', 8.99, NULL, TRUE),
(103, 'Tofu Scramble', 'Vegan tofu breakfast', 'Breakfast', 'Vegan', 5.00, NULL, TRUE),
(104, 'Beef Burger', 'Burger with fries', 'Lunch', 'Normal', 7.50, NULL, TRUE),
(105, 'Lentil Soup', 'Healthy lentil soup', 'Dinner', 'Vegan', 6.25, NULL, TRUE);


INSERT IGNORE INTO Ingredient (ingredient_id, name, current_quantity, unit, expiry_date) VALUES
(1, 'Eggs',             120.00, 'units', DATE_ADD(CURDATE(), INTERVAL 10 DAY)),
(2, 'Chicken Breast',    15.00, 'kg',    DATE_ADD(CURDATE(), INTERVAL 5 DAY)),
(3, 'Rice',              25.00, 'kg',    DATE_ADD(CURDATE(), INTERVAL 90 DAY)),
(4, 'Tofu',              18.00, 'units', DATE_ADD(CURDATE(), INTERVAL 7 DAY)),
(5, 'Lentils',           20.00, 'kg',    DATE_ADD(CURDATE(), INTERVAL 180 DAY));


INSERT IGNORE INTO Recipe (meal_id, ingredient_id, quantity_needed) VALUES
(101, 1, 2.00),     -- Omelet -> Eggs
(102, 2, 0.25),     -- Chicken Curry -> Chicken
(102, 3, 0.30),     -- Chicken Curry -> Rice
(103, 4, 0.50),     -- Tofu Scramble -> Tofu
(105, 5, 0.20);     -- Lentil Soup -> Lentils

INSERT IGNORE INTO Allergen (allergen_id, name) VALUES
(1, 'Eggs'),
(2, 'Gluten'),
(3, 'Soy'),
(4, 'Milk'),
(5, 'Nuts');

INSERT IGNORE INTO Meal_Allergen (meal_id, allergen_id) VALUES
(101, 1),  -- Omelet contains eggs
(102, 2),  -- Chicken Curry contains gluten
(103, 3),  -- Tofu Scramble contains soy
(104, 4),  -- Beef Burger contains milk
(105, 5);  -- Lentil Soup contains nuts

INSERT IGNORE INTO Nutritional_Info (meal_id, calories, fat, protein, carbs) VALUES
(101, 350, 25.0, 18.0, 12.0),
(102, 650, 20.0, 35.0, 80.0),
(103, 400, 15.0, 20.0, 35.0),
(104, 550, 30.0, 30.0, 45.0),
(105, 280, 5.0, 15.0, 40.0);

INSERT IGNORE INTO `Order` (order_id, user_id, pickup_time, status, total_amount, payment_method, pickup_counter) VALUES
(1001, 1, '12:00:00', 'Picked Up', 6.25, 'Student Card', 'A1'),
(1002, 2, '12:15:00', 'Preparing', 9.89, 'Credit Card', 'A2'),
(1003, 3, '12:30:00', 'Pending', 5.00, 'Credit Card', 'A3'),
(1004, 4, '18:00:00', 'Picked Up', 7.50, 'Cash', 'B1'),
(1005, 5, '18:15:00', 'Ready for Pickup', 6.88, 'Credit Card', 'B2');

INSERT IGNORE INTO Order_Item (order_item_id, order_id, meal_id, quantity) VALUES
(1, 1001, 101, 1),
(2, 1002, 102, 1),
(3, 1003, 103, 1),
(4, 1004, 104, 1),
(5, 1005, 105, 1);

INSERT IGNORE INTO Feedback (feedback_id, user_id, meal_id, rating, comment) VALUES
(1, 1, 101, 5, 'Very tasty breakfast'),
(2, 2, 102, 4, 'Good but a bit spicy'),
(3, 3, 103, 5, 'Perfect vegan option'),
(4, 4, 104, 3, 'Burger was okay'),
(5, 5, 105, 4, 'Healthy and filling');



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
