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
