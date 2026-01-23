-- Task - 3
-- mapped_cropped (view / table from Task - 2)

create table mapped_data
as (select * from mapped_crop);

alter table mapped_data modify t_sec datetime not null;
alter table mapped_data add primary key (t_sec);


-- Tables needed mapped_data
-- drop procedure sp_interpolate_column
DELIMITER $$

CREATE PROCEDURE sp_interpolate_column(IN col_name VARCHAR(64))
BEGIN
	-- 1. Create the table name string
	set @tbl_name = concat('cleaned_', col_name, '_data');

	-- 2. Drop the table if exists - can be overwritten
	set @drop_sql = concat('drop table if exists ', @tbl_name);
	prepare drop_stmt from @drop_sql;
	execute drop_stmt;
	deallocate prepare drop_stmt;

    -- 3. Construct the query string using the column name variable
    SET @sql = CONCAT('
        CREATE TABLE ', @tbl_name, ' AS
        WITH bounds AS (
            SELECT t_sec, meas_time, ', col_name, ',
            MAX(CASE WHEN ', col_name, ' IS NOT NULL THEN t_sec END)
                OVER (ORDER BY t_sec ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS prev_t,
            MIN(CASE WHEN ', col_name, ' IS NOT NULL THEN t_sec END)
                OVER (ORDER BY t_sec ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS next_t
            FROM mapped_data
        ),
        values_at_bounds AS (
            SELECT b.*, m1.', col_name, ' AS val_start,
            m2.', col_name, ' AS val_end
            FROM bounds b
            LEFT JOIN mapped_data m1 ON b.prev_t = m1.t_sec
            LEFT JOIN mapped_data m2 ON b.next_t = m2.t_sec
        )
        SELECT t_sec, meas_time, ', col_name, ',
            CASE
                WHEN ', col_name, ' IS NOT NULL THEN ', col_name, '
                ELSE val_start + ((val_end - val_start) * (TIMESTAMPDIFF(SECOND, prev_t, t_sec) / NULLIF(TIMESTAMPDIFF(SECOND, prev_t, next_t), 0)))
            END AS `interpolated_', col_name, '`,
            CASE WHEN ', col_name, ' IS NULL THEN 1 ELSE 0 END AS is_interpolated
        FROM values_at_bounds');

    -- 4. Prepare and execute the built string
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

   -- 5. Print the message (whether table has been created or not)
   select concat('Success: Table ',@tbl_name, ' has been created and populated. ') AS execution_status;

END $$

DELIMITER ;

call sp_interpolate_column('A_L1');

select * from cleaned_A_L1_data
-- where is_interpolated = 1
LIMIT 10000;

-- Fields interpolated "azep"
-- Linear interpolation was used to fill temporal gaps. The formula applied was $y = y_1 + (y_2 - y_1) \cdot \frac{t - t_1}{t_2 - t_1}$,
-- where $t$ represents the target timestamp, and indices 1 and 2 represent the nearest preceding and following valid measurements.
