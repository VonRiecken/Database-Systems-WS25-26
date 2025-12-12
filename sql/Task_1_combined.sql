USE dbsysgr4;

-- ============================================================
-- 1. User Management
-- ============================================================
CREATE TABLE IF NOT EXISTS `User` (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash CHAR(60) NOT NULL,
    role VARCHAR(10) NOT NULL,
    payment_method VARCHAR(50),
    CONSTRAINT chk_user_role CHECK (role IN ('Student', 'Employee'))
);

-- ============================================================
-- 2. Menu Management
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
    CONSTRAINT chk_meal_category CHECK (category IN ('Breakfast','Lunch','Dinner')),
    CONSTRAINT chk_meal_type CHECK (type IN ('Normal','Vegetarian','Vegan')),
    CONSTRAINT chk_meal_price CHECK (price >= 0)
);

CREATE TABLE IF NOT EXISTS `Ingredient` (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    current_quantity DECIMAL(10,2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    CONSTRAINT chk_ingredient_quantity CHECK (current_quantity >= 0)
);

CREATE TABLE IF NOT EXISTS `Recipe` (
    meal_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    quantity_needed DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (meal_id, ingredient_id),
    FOREIGN KEY (meal_id) REFERENCES `Meal`(meal_id),
    FOREIGN KEY (ingredient_id) REFERENCES `Ingredient`(ingredient_id)
);

CREATE TABLE IF NOT EXISTS `Allergen` (
    allergen_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS `Meal_Allergen` (
    meal_id INT NOT NULL,
    allergen_id INT NOT NULL,
    PRIMARY KEY (meal_id, allergen_id),
    FOREIGN KEY (meal_id) REFERENCES `Meal`(meal_id),
    FOREIGN KEY (allergen_id) REFERENCES `Allergen`(allergen_id)
);

CREATE TABLE IF NOT EXISTS `Nutritional_Info` (
    meal_id INT PRIMARY KEY,
    calories INT NOT NULL,
    fat DECIMAL(5,2),
    protein DECIMAL(5,2),
    carbs DECIMAL(5,2),
    FOREIGN KEY (meal_id) REFERENCES `Meal`(meal_id)
);

-- ============================================================
-- 3. Order Management
-- ============================================================
CREATE TABLE IF NOT EXISTS `Order` (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    pickup_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL,
    total_amount DECIMAL(6,2) NOT NULL,
    pickup_counter VARCHAR(10),
    CONSTRAINT chk_order_status CHECK (status IN ('Pending','Preparing','Ready for Pickup','Picked Up','Cancelled')),
    FOREIGN KEY (user_id) REFERENCES `User`(user_id)
);

CREATE TABLE IF NOT EXISTS `Order_Item` (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    meal_id INT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT chk_item_quantity CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id) ON DELETE CASCADE,
    FOREIGN KEY (meal_id) REFERENCES `Meal`(meal_id)
);

-- ============================================================
-- 4. Feedback
-- ============================================================
CREATE TABLE IF NOT EXISTS `Feedback` (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    meal_id INT NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    feedback_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_rating_value CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (user_id) REFERENCES `User`(user_id),
    FOREIGN KEY (meal_id) REFERENCES `Meal`(meal_id)
);

-- ============================================================
-- Sample data insertion (in dependency order)
-- ============================================================

-- Users
INSERT IGNORE INTO `User` (user_id, name, email, password_hash, role, payment_method) VALUES
(1, 'John', 'john.j@uni.edu', '$2a$10$abcdef...hashed1', 'Student', 'University Balance'),
(2, 'Daniel', 'daniel.s@work.edu', '$2a$10$abcdef...hashed2', 'Employee', 'Credit Card'),
(3, 'Sulthan', 'sulthan.d@uni.edu', '$2a$10$abcdef...hashed3', 'Student', 'Debit Card'),
(4, 'Sean', 'sean.l@work.edu', '$2a$10$abcdef...hashed4', 'Employee', 'Credit Card'),
(5, 'Rene', 'rene.w@uni.edu', '$2a$10$abcdef...hashed5', 'Student', 'University Balance');

-- Meals
INSERT IGNORE INTO `Meal` (meal_id, name, category, type, price) VALUES
(101, 'Veggie Omelet', 'Breakfast', 'Vegetarian', 6.25),
(102, 'Chicken Curry', 'Lunch', 'Normal', 8.99),
(103, 'Tofu Scramble', 'Breakfast', 'Vegan', 5.00),
(104, 'Beef Burger', 'Lunch', 'Normal', 7.50),
(105, 'Lentil Soup', 'Dinner', 'Vegan', 6.25);

-- Ingredients
INSERT IGNORE INTO `Ingredient` (ingredient_id, name, current_quantity, unit) VALUES
(1, 'Chicken Breast', 10.00, 'kg'),
(2, 'Rice', 20.00, 'kg'),
(3, 'Tofu', 15.00, 'units'),
(4, 'Eggs', 100.00, 'units'),
(5, 'Onion', 50.00, 'kg');

-- Recipe
INSERT IGNORE INTO `Recipe` (meal_id, ingredient_id, quantity_needed) VALUES
(102, 1, 0.20),
(102, 2, 0.30),
(101, 4, 2.00),
(103, 3, 0.50),
(105, 5, 0.15);

-- Allergens
INSERT IGNORE INTO `Allergen` (allergen_id, name) VALUES
(1,'Gluten'),
(2,'Dairy'),
(3,'Eggs'),
(4,'Nuts'),
(5,'Soy');

-- Meal_Allergen
INSERT IGNORE INTO `Meal_Allergen` (meal_id, allergen_id) VALUES
(101, 3),
(102, 2),
(104, 1),
(104, 2),
(103, 5);

-- Nutritional Info
INSERT IGNORE INTO `Nutritional_Info` (meal_id, calories, fat, protein, carbs) VALUES
(101, 350, 25.0, 18.0, 12.0),
(102, 650, 20.0, 35.0, 80.0),
(103, 400, 15.0, 20.0, 35.0),
(104, 550, 30.0, 30.0, 45.0),
(105, 280, 5.0, 15.0, 40.0);



------------------------ ##################################### ------------------------

------------------------ STORED VIEWS ------------------------------

-- Monthly User Meal Report
CREATE VIEW Monthly_User_Meal_Report AS
SELECT
    DATE_FORMAT(O.order_date, '%Y-%m') AS month,
    U.user_id,
    U.role,
    U.name AS user_name,
    M.name AS meal_name,
    OI.quantity,
    M.price,
    (M.price * OI.quantity) AS gross_price,
    CASE
        WHEN U.role = 'Student' THEN (M.price * OI.quantity)
        -- Employees get a 10% surcharge (multiplied by 1.10)
        WHEN U.role = 'Employee' THEN (M.price * OI.quantity * 1.10)
        ELSE (M.price * OI.quantity)
    END AS final_charge
FROM
    dbsysgr4.`Order` O
JOIN
    User U ON O.user_id = U.user_id
JOIN
    Order_Item OI ON O.order_id = OI.order_id
JOIN
    Meal M ON OI.meal_id = M.meal_id;

-- Monthly Revenue Summary
CREATE VIEW Monthly_Revenue_Summary AS
SELECT
    DATE_FORMAT(O.order_date, '%Y-%m') AS month,
    SUM(total_amount) AS total_revenue
FROM
    dbsysgr4.`Order` O
WHERE
    status IN ('Picked Up') -- Only include fulfilled orders in revenue
GROUP BY
    month
ORDER BY
    month;

-- Check Feedback

------------------------ ##################################### ------------------------

------------------------ STORED FUNCTIONS ------------------------------


-- 3. Total Order Amount Calculation
DELIMITER $$

CREATE FUNCTION Calculate_Order_Total(order_id_in INT)
RETURNS DECIMAL(6,2)
DETERMINISTIC
BEGIN
    DECLARE total_price DECIMAL(6,2);
    DECLARE user_role VARCHAR(10);

    -- Get user role
    SELECT U.role
    INTO user_role
    FROM `Order` O
    JOIN `User` U ON O.user_id = U.user_id
    WHERE O.order_id = order_id_in;

    -- Calculate total price
    SELECT SUM(M.price * OI.quantity)
    INTO total_price
    FROM Order_Item OI
    JOIN Meal M ON OI.meal_id = M.meal_id
    WHERE OI.order_id = order_id_in;

    -- Apply surcharge
    IF user_role = 'Employee' THEN
        RETURN total_price * 1.10;
    ELSE
        RETURN total_price;
    END IF;
END$$

DELIMITER ;


------------------------ ##################################### ------------------------

------------------------ STORED PROCEEDURE ------------------------------

DELIMITER $$

CREATE PROCEDURE sp_place_order(
    IN p_user_id INT,
    IN p_meal_id INT,
    IN p_quantity INT,
    IN p_pickup_time TIME
)
BEGIN
    DECLARE v_role VARCHAR(10);
    DECLARE v_meal_price DECIMAL(5,2);
    DECLARE v_is_available BOOLEAN;
    DECLARE v_total_amount DECIMAL(6,2);
    DECLARE v_new_order_id INT;

    -- 1. Validate quantity
    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Quantity must be greater than 0';
    END IF;

    -- 2. Fetch meal details
    SELECT price, is_available
    INTO v_meal_price, v_is_available
    FROM Meal
    WHERE meal_id = p_meal_id;

    IF v_meal_price IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Meal does not exist';
    END IF;

    IF v_is_available = FALSE THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Meal is currently sold out';
    END IF;

    -- 3. Fetch user role
    SELECT role
    INTO v_role
    FROM `User`
    WHERE user_id = p_user_id;

    IF v_role IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    -- 4. Calculate base total
    SET v_total_amount = v_meal_price * p_quantity;

    -- Employee surcharge
    IF v_role = 'Employee' THEN
        SET v_total_amount = v_total_amount * 1.10;
    END IF;

    -- 5. Insert order header
    INSERT INTO `Order` (user_id, pickup_time, status, total_amount)
    VALUES (p_user_id, p_pickup_time, 'Pending', v_total_amount);

    SET v_new_order_id = LAST_INSERT_ID();

    -- 6. Insert order item
    INSERT INTO Order_Item (order_id, meal_id, quantity)
    VALUES (v_new_order_id, p_meal_id, p_quantity);

	-- 7. Log Success (Optional)
	SELECT CONCAT('Order ', v_new_order_id, ' placed successfully. Total: $', v_total_amount) AS notice;
END$$

DELIMITER ;
