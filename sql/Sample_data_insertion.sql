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
