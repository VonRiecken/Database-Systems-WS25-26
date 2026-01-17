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
    payment_details VARCHAR(50),
    CONSTRAINT chk_user_role CHECK (role IN ('Student', 'Employee', 'Admin')),
    CONSTRAINT uq_user_email UNIQUE (email)
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
    payment_method VARCHAR(50),
    pickup_counter VARCHAR(10),
    CONSTRAINT chk_order_status CHECK (status IN ('Pending','Preparing','Ready for Pickup','Picked Up','Cancelled')),
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('Cash', 'Credit Card', 'Student Card', 'Other')),
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
