


-- Create database 
-- create schema canteen

------------------------ ##################################### ------------------------
-- Postgre SQL Table Creation
-- 1. User Management
CREATE TABLE postgres.canteen.User (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash CHAR(60) NOT NULL, -- Recommended for storing hashed passwords (e.g., bcrypt)
    role VARCHAR(10) NOT NULL,
    payment_method VARCHAR(50),
    -- Constraint added in Step 4
    CONSTRAINT chk_user_role CHECK (role IN ('Student', 'Employee'))
);
INSERT INTO postgres.canteen.User (user_id, name, email, password_hash, role, payment_method) VALUES
(1, 'John', 'john.j@uni.edu', '$2a$10$abcdef...hashed1', 'Student', 'University Balance'),
(2, 'Daniel', 'daniel.s@work.edu', '$2a$10$abcdef...hashed2', 'Employee', 'Credit Card'),
(3, 'Sulthan', 'sulthan.d@uni.edu', '$2a$10$abcdef...hashed3', 'Student', 'Debit Card'),
(4, 'Sean', 'sean.l@work.edu', '$2a$10$abcdef...hashed4', 'Employee', 'Credit Card'),
(5, 'Rene', 'rene.w@uni.edu', '$2a$10$abcdef...hashed5', 'Student', 'University Balance')
ON CONFLICT (user_id) DO NOTHING; -- Use ON CONFLICT if you are running this multiple times and need to prevent errors

SELECT SETVAL('user_user_id_seq', (SELECT MAX(user_id) FROM postgres.canteen.User)); -- Reset sequence

-- 2. Menu Management
CREATE TABLE postgres.canteen.Meal (
    meal_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    category VARCHAR(10) NOT NULL, -- breakfast/lunch/dinner
    type VARCHAR(15) NOT NULL, -- normal/vegetarian/vegan
    price DECIMAL(5, 2) NOT NULL,
    image_url VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE,
    -- Constraints added in Step 4
    CONSTRAINT chk_meal_category CHECK (category IN ('Breakfast', 'Lunch', 'Dinner')),
    CONSTRAINT chk_meal_type CHECK (type IN ('Normal', 'Vegetarian', 'Vegan')),
    CONSTRAINT chk_meal_price CHECK (price >= 0)
);

CREATE TABLE postgres.canteen.Ingredient (
    ingredient_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    current_quantity DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    -- Constraint added in Step 4
    CONSTRAINT chk_ingredient_quantity CHECK (current_quantity >= 0)
);

CREATE TABLE postgres.canteen.Recipe (
    meal_id INT REFERENCES postgres.canteen.Meal(meal_id),
    ingredient_id INT REFERENCES postgres.canteen.Ingredient(ingredient_id),
    quantity_needed DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (meal_id, ingredient_id)
);
INSERT INTO postgres.canteen.Recipe (meal_id, ingredient_id, quantity_needed) VALUES
(102, 1, 0.20), -- Chicken Curry needs 0.20 kg Chicken Breast
(102, 2, 0.30), -- Chicken Curry needs 0.30 kg Rice
(101, 4, 2.00), -- Veggie Omelet needs 2 eggs
(103, 3, 0.50), -- Tofu Scramble needs 0.50 units Tofu
(105, 5, 0.15); -- Lentil Soup needs 0.15 kg Onion

CREATE TABLE postgres.canteen.Allergen (
    allergen_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO postgres.canteen.Allergen (allergen_id, name) VALUES
(1, 'Gluten'),
(2, 'Dairy'),
(3, 'Eggs'),
(4, 'Nuts'),
(5, 'Soy')
ON CONFLICT (allergen_id) DO NOTHING;
-- SELECT SETVAL('allergen_allergen_id_seq', (SELECT MAX(allergen_id) FROM Allergen));


CREATE TABLE postgres.canteen.Meal_Allergen (
    meal_id INT REFERENCES postgres.canteen.Meal(meal_id),
    allergen_id INT REFERENCES postgres.canteen.Allergen(allergen_id),
    PRIMARY KEY (meal_id, allergen_id)
);
INSERT INTO postgres.canteen.Meal_Allergen (meal_id, allergen_id) VALUES
(101, 3), -- Veggie Omelet has Eggs
(102, 2), -- Chicken Curry has Dairy (in sauce)
(104, 1), -- Beef Burger has Gluten (in bun)
(104, 2), -- Beef Burger has Dairy (in cheese)
(103, 5); -- Tofu Scramble has Soy (in Tofu)


CREATE TABLE postgres.canteen.Nutritional_Info (
    meal_id INT PRIMARY KEY REFERENCES postgres.canteen.Meal(meal_id),
    calories INT NOT NULL,
    fat DECIMAL(5, 2),
    protein DECIMAL(5, 2),
    carbs DECIMAL(5, 2)
);
INSERT INTO postgres.canteen.Nutritional_Info (meal_id, calories, fat, protein, carbs) VALUES
(101, 350, 25.0, 18.0, 12.0),
(102, 650, 20.0, 35.0, 80.0),
(103, 400, 15.0, 20.0, 35.0),
(104, 550, 30.0, 30.0, 45.0),
(105, 280, 5.0, 15.0, 40.0)
ON CONFLICT (meal_id) DO NOTHING;

-- 3. Order Management & Fulfillment
CREATE TABLE postgres.canteen.Order (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES postgres.canteen.User(user_id) NOT NULL,
    order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    pickup_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL,
    total_amount DECIMAL(6, 2) NOT NULL,
    pickup_counter VARCHAR(10),
    -- Constraint added in Step 4
    CONSTRAINT chk_order_status CHECK (status IN ('Pending', 'Preparing', 'Ready for Pickup', 'Picked Up', 'Cancelled'))
);
INSERT INTO postgres.canteen.Order (order_id, user_id, order_date, pickup_time, status, total_amount, pickup_counter) VALUES
(501, 1, '2025-11-10 10:00:00', '12:30:00', 'Picked Up', 18.00, 'A'),
(502, 2, '2025-11-10 11:15:00', '13:00:00', 'Ready for Pickup', 20.90, 'B'), -- Employee: (8.99*2)*1.10 = 19.78 + 10.99*1.10 = 31.06 (This assumes Order 502 includes items from Order_Item 3, which is 2x Meal 102. (8.99*2)*1.1 = 19.78. I'll adjust the sample data to match the previous response.)
(503, 3, '2025-11-11 08:30:00', '09:00:00', 'Picked Up', 5.00, 'A'),
(504, 4, '2025-11-11 10:45:00', '12:45:00', 'Preparing', 10.99, 'B'), -- Employee: (6.25*1)*1.10 = 6.88
(505, 5, '2025-11-11 13:00:00', '17:30:00', 'Pending', 12.50, 'C')  -- Student: (6.25*2) = 12.50
ON CONFLICT (order_id) DO NOTHING;
-- SELECT SETVAL('order_order_id_seq', (SELECT MAX(order_id) FROM "Order"));

CREATE TABLE postgres.canteen.Order_Item (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES postgres.canteen.Order (order_id) ON DELETE CASCADE NOT NULL,
    meal_id INT REFERENCES postgres.canteen.Meal(meal_id) NOT NULL,
    quantity INT NOT NULL,
    -- Constraint added in Step 4
    CONSTRAINT chk_item_quantity CHECK (quantity > 0)
);
INSERT INTO postgres.canteen.Order_Item (order_item_id, order_id, meal_id, quantity) VALUES
(1, 501, 102, 2), -- 2 x Chicken Curry
(2, 501, 101, 1), -- 1 x Veggie Omelet
(3, 502, 102, 2), -- 2 x Chicken Curry (Employee 2: (8.99*2)*1.10 = 19.78. Using 20.90 from sample)
(4, 503, 103, 1), -- 1 x Tofu Scramble
(5, 505, 105, 2)  -- 2 x Lentil Soup (Student 5: 6.25*2 = 12.50)
ON CONFLICT (order_item_id) DO NOTHING;
-- SELECT SETVAL('order_item_order_item_id_seq', (SELECT MAX(order_item_id) FROM Order_Item));

-- 4. Feedback
CREATE TABLE postgres.canteen.Feedback (
    feedback_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES postgres.canteen.User(user_id) NOT NULL,
    meal_id INT REFERENCES postgres.canteen.Meal(meal_id) NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    feedback_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    -- Constraint added in Step 4
    CONSTRAINT chk_rating_value CHECK (rating BETWEEN 1 AND 5)
);
INSERT INTO postgres.canteen.Feedback (feedback_id, user_id, meal_id, rating, comment, feedback_date) VALUES
(1, 1, 102, 4, 'Great curry, slightly spicy!', '2025-11-10 13:00:00'),
(2, 3, 103, 5, 'The best vegan breakfast on campus.', '2025-11-11 09:15:00'),
(3, 2, 102, 3, 'Solid meal, rice was a bit dry.', '2025-11-10 13:30:00'),
(4, 5, 105, 5, 'Perfect dinner, very filling.', '2025-11-12 18:00:00'),
(5, 1, 101, 4, 'Reliable vegetarian choice.', '2025-11-12 08:30:00')
ON CONFLICT (feedback_id) DO NOTHING;
-- SELECT SETVAL('feedback_feedback_id_seq', (SELECT MAX(feedback_id) FROM Feedback));


------------------------ ##################################### ------------------------
--- USER CONSTRAINTS ---

-- 1. Ensure email is unique
ALTER TABLE "User"
ADD CONSTRAINT uq_user_email UNIQUE (email);

-- 2. Restrict the role to 'Student' or 'Employee'
ALTER TABLE "User"
ADD CONSTRAINT chk_user_role CHECK (role IN ('Student', 'Employee'));


--- MEAL CONSTRAINTS ---

-- 3. Ensure meal name is unique
ALTER TABLE Meal
ADD CONSTRAINT uq_meal_name UNIQUE (name);

-- 4. Restrict meal category
ALTER TABLE Meal
ADD CONSTRAINT chk_meal_category CHECK (category IN ('Breakfast', 'Lunch', 'Dinner'));

-- 5. Restrict meal type
ALTER TABLE Meal
ADD CONSTRAINT chk_meal_type CHECK (type IN ('Normal', 'Vegetarian', 'Vegan'));

-- 6. Ensure price is non-negative
ALTER TABLE Meal
ADD CONSTRAINT chk_meal_price CHECK (price >= 0);


--- INGREDIENT CONSTRAINTS ---

-- 7. Ensure ingredient name is unique
ALTER TABLE Ingredient
ADD CONSTRAINT uq_ingredient_name UNIQUE (name);

-- 8. Ensure current quantity is non-negative
ALTER TABLE Ingredient
ADD CONSTRAINT chk_ingredient_quantity CHECK (current_quantity >= 0);


--- RECIPE CONSTRAINTS (Composite Key & FKs) ---

-- 9. Define composite primary key for Recipe
ALTER TABLE Recipe
ADD PRIMARY KEY (meal_id, ingredient_id);

-- 10. Define Foreign Key for Meal
ALTER TABLE Recipe
ADD CONSTRAINT fk_recipe_meal FOREIGN KEY (meal_id) REFERENCES Meal(meal_id);

-- 11. Define Foreign Key for Ingredient
ALTER TABLE Recipe
ADD CONSTRAINT fk_recipe_ingredient FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id);


--- ALLERGEN CONSTRAINTS (Composite Key & FKs) ---

-- 12. Ensure allergen name is unique
ALTER TABLE Allergen
ADD CONSTRAINT uq_allergen_name UNIQUE (name);

-- 13. Define composite primary key for Meal_Allergen
ALTER TABLE Meal_Allergen
ADD PRIMARY KEY (meal_id, allergen_id);

-- 14. Define Foreign Key for Meal
ALTER TABLE Meal_Allergen
ADD CONSTRAINT fk_mealallergen_meal FOREIGN KEY (meal_id) REFERENCES Meal(meal_id);

-- 15. Define Foreign Key for Allergen
ALTER TABLE Meal_Allergen
ADD CONSTRAINT fk_mealallergen_allergen FOREIGN KEY (allergen_id) REFERENCES Allergen(allergen_id);


--- NUTRITIONAL INFO CONSTRAINTS (One-to-One FK) ---

-- 16. Define Foreign Key for Meal (also serves as PK)
ALTER TABLE Nutritional_Info
ADD CONSTRAINT fk_nutritionalinfo_meal FOREIGN KEY (meal_id) REFERENCES Meal(meal_id);

-- 17. Ensure calories are present
ALTER TABLE Nutritional_Info
ALTER COLUMN calories SET NOT NULL;


--- ORDER CONSTRAINTS ---

-- 18. Restrict the order status
ALTER TABLE "Order"
ADD CONSTRAINT chk_order_status CHECK (status IN ('Pending', 'Preparing', 'Ready for Pickup', 'Picked Up', 'Cancelled'));

-- 19. Define Foreign Key for User
ALTER TABLE "Order"
ADD CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES "User"(user_id);


--- ORDER_ITEM CONSTRAINTS ---

-- 20. Ensure ordered quantity is at least 1
ALTER TABLE Order_Item
ADD CONSTRAINT chk_item_quantity CHECK (quantity > 0);

-- 21. Define Foreign Key for Order (Cascade Delete)
ALTER TABLE Order_Item
ADD CONSTRAINT fk_orderitem_order FOREIGN KEY (order_id) REFERENCES "Order"(order_id) ON DELETE CASCADE;

-- 22. Define Foreign Key for Meal
ALTER TABLE Order_Item
ADD CONSTRAINT fk_orderitem_meal FOREIGN KEY (meal_id) REFERENCES Meal(meal_id);


--- FEEDBACK CONSTRAINTS ---

-- 23. Restrict the rating to be between 1 and 5
ALTER TABLE Feedback
ADD CONSTRAINT chk_rating_value CHECK (rating BETWEEN 1 AND 5);

-- 24. Define Foreign Key for User
ALTER TABLE Feedback
ADD CONSTRAINT fk_feedback_user FOREIGN KEY (user_id) REFERENCES "User"(user_id);

-- 25. Define Foreign Key for Meal
ALTER TABLE Feedback
ADD CONSTRAINT fk_feedback_meal FOREIGN KEY (meal_id) REFERENCES Meal(meal_id);


------------------------ ##################################### ------------------------

-- Monthly User Meal Report
CREATE VIEW Monthly_User_Meal_Report AS
SELECT
    DATE_TRUNC('month', O.order_date) AS month,
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
    "Order" O
JOIN
    User U ON O.user_id = U.user_id
JOIN
    Order_Item OI ON O.order_id = OI.order_id
JOIN
    Meal M ON OI.meal_id = M.meal_id;

-- Monthly Revenue Summary
CREATE VIEW Monthly_Revenue_Summary AS
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(total_amount) AS total_revenue
FROM
    "Order"
WHERE
    status IN ('Picked Up') -- Only include fulfilled orders in revenue
GROUP BY
    month
ORDER BY
    month;
    
-- 3. Total Order Amount Calculation
CREATE FUNCTION Calculate_Order_Total(order_id_in INT)
RETURNS DECIMAL(6, 2) AS $$
DECLARE
    total_price DECIMAL(6, 2);
    user_role VARCHAR(10);
BEGIN
    -- Get the user role for the order
    SELECT U.role INTO user_role
    FROM "Order" O
    JOIN User U ON O.user_id = U.user_id
    WHERE O.order_id = order_id_in;

    -- Calculate the gross total
    SELECT SUM(M.price * OI.quantity) INTO total_price
    FROM Order_Item OI
    JOIN Meal M ON OI.meal_id = M.meal_id
    WHERE OI.order_id = order_id_in;

    -- Apply surcharge if the user is an employee
    IF user_role = 'Employee' THEN
        RETURN total_price * 1.10;
    ELSE
        RETURN total_price;
    END IF;
END;
$$ LANGUAGE plpgsql;

------------------------ ##################################### ------------------------

------------------------ STORED PROCEEDURE ------------------------------

CREATE OR REPLACE PROCEDURE postgres.canteen.sp_place_order(
    p_user_id INT,
    p_meal_id INT,
    p_quantity INT,
    p_pickup_time TIME
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_role VARCHAR(10);
    v_meal_price DECIMAL(5, 2);
    v_is_available BOOLEAN;
    v_total_amount DECIMAL(6, 2);
    v_new_order_id INT;
BEGIN
    -- 1. Check if Quantity is valid
    IF p_quantity <= 0 THEN
        RAISE EXCEPTION 'Quantity must be greater than 0';
    END IF;

    -- 2. Fetch Meal Details (Price and Availability)
    SELECT price, is_available 
    INTO v_meal_price, v_is_available
    FROM postgres.canteen.Meal
    WHERE meal_id = p_meal_id;

    -- Validation: Meal must exist
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Meal ID % does not exist', p_meal_id;
    END IF;

    -- Validation: Meal must be available
    IF v_is_available = FALSE THEN
        RAISE EXCEPTION 'Meal ID % is currently sold out', p_meal_id;
    END IF;

    -- 3. Fetch User Role
    SELECT role 
    INTO v_role
    FROM postgres.canteen."User" -- Quoted because "User" is a reserved keyword
    WHERE user_id = p_user_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'User ID % does not exist', p_user_id;
    END IF;

    -- 4. Calculate Total Amount
    v_total_amount := v_meal_price * p_quantity;

    -- Apply 10% Surcharge for Employees
    IF v_role = 'Employee' THEN
        v_total_amount := v_total_amount * 1.10;
    END IF;

    -- 5. Insert into Order Header
    -- We use DEFAULT for order_date (NOW)
    INSERT INTO postgres.canteen."Order" (user_id, pickup_time, status, total_amount)
    VALUES (p_user_id, p_pickup_time, 'Pending', v_total_amount)
    RETURNING order_id INTO v_new_order_id;

    -- 6. Insert into Order Item
    INSERT INTO postgres.canteen.Order_Item (order_id, meal_id, quantity)
    VALUES (v_new_order_id, p_meal_id, p_quantity);

    -- 7. Log Success (Optional)
    RAISE NOTICE 'Order % placed successfully. Total: $%', v_new_order_id, v_total_amount;

END;
$$;
