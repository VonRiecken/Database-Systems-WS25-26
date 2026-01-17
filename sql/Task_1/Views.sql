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

