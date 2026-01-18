-- Problem 0
-- Load Data
-- Create the table with the correct structure
CREATE TABLE umg801_data (
    _time DATETIME(3),
    AZEP FLOAT,
    A_L1 FLOAT,
    A_L2 FLOAT,
    A_L3 FLOAT,
    A_N FLOAT,
    COS_PHI_L1 FLOAT,
    COS_PHI_L2 FLOAT,
    COS_PHI_L3 FLOAT,
    THDI_L1 FLOAT,
    THDI_L2 FLOAT,
    THDI_L3 FLOAT,
    THDU_L1N FLOAT,
    THDU_L2N FLOAT,
    THDU_L3N FLOAT,
    V_L1_L2 FLOAT,
    V_L1_N FLOAT,
    V_L2_L3 FLOAT,
    V_L2_N FLOAT,
    V_L3_L1 FLOAT,
    V_L3_N FLOAT,
    PRIMARY KEY (_time)
);

-- Load the data into the table structure 
LOAD DATA LOCAL INFILE 'C:/Users/asus/temp/umg801_dbs_lecture_data/01_30d_schneider_umg801_dbs_lecture.csv'
INTO TABLE umg801_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS -- Skips the header row
(@_time, @_measurement, AZEP, A_L1, A_L2, A_L3, A_N, COS_PHI_L1,
COS_PHI_L2,COS_PHI_L3,THDI_L1,THDI_L2,THDI_L3,THDU_L1N,THDU_L2N,
THDU_L3N,V_L1_L2,V_L1_N,V_L2_L3,V_L2_N,V_L3_L1,V_L3_N)
SET _time = STR_TO_DATE(@_time, '%Y-%m-%d %H:%i:%s.%f');

LOAD DATA LOCAL INFILE 'C:/Users/asus/temp/umg801_dbs_lecture_data/02_30d_schneider_umg801_dbs_lecture.csv'
INTO TABLE umg801_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS -- Skips the header row
(@_time, @_measurement, AZEP, A_L1, A_L2, A_L3, A_N, COS_PHI_L1,
COS_PHI_L2,COS_PHI_L3,THDI_L1,THDI_L2,THDI_L3,THDU_L1N,THDU_L2N,
THDU_L3N,V_L1_L2,V_L1_N,V_L2_L3,V_L2_N,V_L3_L1,V_L3_N)
SET _time = STR_TO_DATE(@_time, '%Y-%m-%d %H:%i:%s.%f');

LOAD DATA LOCAL INFILE 'C:/Users/asus/temp/umg801_dbs_lecture_data/03_30d_schneider_umg801_dbs_lecture.csv'
INTO TABLE umg801_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS -- Skips the header row
(@_time, @_measurement, AZEP, A_L1, A_L2, A_L3, A_N, COS_PHI_L1,
COS_PHI_L2,COS_PHI_L3,THDI_L1,THDI_L2,THDI_L3,THDU_L1N,THDU_L2N,
THDU_L3N,V_L1_L2,V_L1_N,V_L2_L3,V_L2_N,V_L3_L1,V_L3_N)
SET _time = STR_TO_DATE(@_time, '%Y-%m-%d %H:%i:%s.%f');

LOAD DATA LOCAL INFILE 'C:/Users/asus/temp/umg801_dbs_lecture_data/04_30d_schneider_umg801_dbs_lecture.csv'
INTO TABLE umg801_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS -- Skips the header row
(@_time, @_measurement, AZEP, A_L1, A_L2, A_L3, A_N, COS_PHI_L1,
COS_PHI_L2,COS_PHI_L3,THDI_L1,THDI_L2,THDI_L3,THDU_L1N,THDU_L2N,
THDU_L3N,V_L1_L2,V_L1_N,V_L2_L3,V_L2_N,V_L3_L1,V_L3_N)
SET _time = STR_TO_DATE(@_time, '%Y-%m-%d %H:%i:%s.%f');

LOAD DATA LOCAL INFILE 'C:/Users/asus/temp/umg801_dbs_lecture_data/05_30d_schneider_umg801_dbs_lecture.csv'
INTO TABLE umg801_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS -- Skips the header row
(@_time, @_measurement, AZEP, A_L1, A_L2, A_L3, A_N, COS_PHI_L1,
COS_PHI_L2,COS_PHI_L3,THDI_L1,THDI_L2,THDI_L3,THDU_L1N,THDU_L2N,
THDU_L3N,V_L1_L2,V_L1_N,V_L2_L3,V_L2_N,V_L3_L1,V_L3_N)
SET _time = STR_TO_DATE(@_time, '%Y-%m-%d %H:%i:%s.%f');

LOAD DATA LOCAL INFILE 'C:/Users/asus/temp/umg801_dbs_lecture_data/06_30d_schneider_umg801_dbs_lecture.csv'
INTO TABLE umg801_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS -- Skips the header row
(@_time, @_measurement, AZEP, A_L1, A_L2, A_L3, A_N, COS_PHI_L1,
COS_PHI_L2,COS_PHI_L3,THDI_L1,THDI_L2,THDI_L3,THDU_L1N,THDU_L2N,
THDU_L3N,V_L1_L2,V_L1_N,V_L2_L3,V_L2_N,V_L3_L1,V_L3_N)
SET _time = STR_TO_DATE(@_time, '%Y-%m-%d %H:%i:%s.%f');

LOAD DATA LOCAL INFILE 'C:/Users/asus/temp/umg801_dbs_lecture_data/07_30d_schneider_umg801_dbs_lecture.csv'
INTO TABLE umg801_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS -- Skips the header row
(@_time, @_measurement, AZEP, A_L1, A_L2, A_L3, A_N, COS_PHI_L1,
COS_PHI_L2,COS_PHI_L3,THDI_L1,THDI_L2,THDI_L3,THDU_L1N,THDU_L2N,
THDU_L3N,V_L1_L2,V_L1_N,V_L2_L3,V_L2_N,V_L3_L1,V_L3_N)
SET _time = STR_TO_DATE(@_time, '%Y-%m-%d %H:%i:%s.%f');

-- check for duplicates
SELECT *
FROM umg801_data
WHERE _time IN (
    SELECT _time
    FROM umg801_data
    GROUP BY _time
    HAVING COUNT(*) > 1
)
ORDER BY _time;

-- To copy for a backup
CREATE TABLE umg801_backup AS
SELECT * FROM umg801_data;

-- Create partitioning for more efficient parsing
-- Test best partition performance
-- create base sampling table for 10% of random samples
CREATE TABLE umg801_sample_base AS 
SELECT * FROM umg801_data 
WHERE RAND() < 0.1;

--  Yearly Partitioned
CREATE TABLE test_yearly (LIKE umg801_sample_base);
ALTER TABLE test_yearly PARTITION BY RANGE (YEAR(_time)) (
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p_max VALUES LESS THAN MAXVALUE
);
INSERT INTO test_yearly SELECT * FROM umg801_sample_base;

--  Monthly Partitioned
CREATE TABLE test_monthly (LIKE umg801_sample_base);
ALTER TABLE test_monthly PARTITION BY RANGE COLUMNS(_time) (
    PARTITION p2025_07 VALUES LESS THAN ('2025-08-01'),
    PARTITION p2025_08 VALUES LESS THAN ('2025-09-01'),
    PARTITION p_max VALUES LESS THAN MAXVALUE
);
INSERT INTO test_monthly SELECT * FROM umg801_sample_base;

--  Daily Partitioned
CREATE TABLE test_daily (LIKE umg801_sample_base);
ALTER TABLE test_daily PARTITION BY RANGE COLUMNS(_time) (
    PARTITION p2025_07_01 VALUES LESS THAN ('2025-07-02'),
    PARTITION p2025_07_02 VALUES LESS THAN ('2025-07-03'),
    PARTITION p_max VALUES LESS THAN MAXVALUE
);
INSERT INTO test_daily SELECT * FROM umg801_sample_base;

-- test performance of each partitioning method
SET profiling = 1;

-- Test Query: Average AZEP for July 1st
SELECT AVG(AZEP) FROM umg801_sample_base    WHERE _time BETWEEN '2025-07-01' AND '2025-07-02';
SELECT AVG(AZEP) FROM test_yearly  WHERE _time BETWEEN '2025-07-01' AND '2025-07-02';
SELECT AVG(AZEP) FROM test_monthly WHERE _time BETWEEN '2025-07-01' AND '2025-07-02';
SELECT AVG(AZEP) FROM test_daily   WHERE _time BETWEEN '2025-07-01' AND '2025-07-02';

SHOW PROFILES;
-- RESULTS
-- Duration	(s)	- partitioning
-- 1.94460120 	- none
-- 2.12407396 	- yearly
-- 0.31221825	- monthly
-- 0.01354534 	- daily
-- daily was fastest but monthly partitioning is the best choice because it provides a massive speed boost 
-- while avoiding the "file clutter" and management headaches that come with creating hundreds of individual daily files
 
-- cleanup
-- Drop the 10% base sample table and the performance testing tables
DROP TABLE IF EXISTS umg801_sample_base;
DROP TABLE IF EXISTS test_none;
DROP TABLE IF EXISTS test_yearly;
DROP TABLE IF EXISTS test_monthly;
DROP TABLE IF EXISTS test_daily;

-- alter table to partition
ALTER TABLE umg801_data
PARTITION BY RANGE COLUMNS(_time) (
    PARTITION p2025_07 VALUES LESS THAN ('2025-08-01'),
    PARTITION p2025_08 VALUES LESS THAN ('2025-09-01'),
    PARTITION p2025_09 VALUES LESS THAN ('2025-10-01'),
    PARTITION p2025_10 VALUES LESS THAN ('2025-11-01'),
    PARTITION p2025_11 VALUES LESS THAN ('2025-12-01'),
    PARTITION p2025_12 VALUES LESS THAN ('2026-01-01'),
    PARTITION p2026_01 VALUES LESS THAN ('2026-02-01'),
    PARTITION p_future VALUES LESS THAN (MAXVALUE)
);

-- create a Sandbox table to test sql commands quickly
CREATE TABLE IF NOT EXISTS umg801_sandbox AS
SELECT * FROM umg801_data
LIMIT 10000;

-- Design Justification:
-- DATETIME(3): Supports the millisecond resolution of the logger.
-- FLOAT: Suitable for analog measurement values.
-- PRIMARY KEY(_time): Facilitates efficient range scans and "ORDER BY _time" operations, which are essential for time-series data.
-- PARTITION BY RANGE: Physically segmenting the 14.6M rows into monthly files to ensure query performance remains consistent as the dataset grows.

-- ------------------------------------------------------------
-- 2) Row Count – How many rows of data are there?
-- ------------------------------------------------------------
SELECT COUNT(*) AS row_count
FROM umg801_data;


-- ------------------------------------------------------------
-- 3) Recording Time Range – Min/Max timestamps & total duration
-- ------------------------------------------------------------
SELECT
    MIN(_time) AS min_time,
    MAX(_time) AS max_time,
    TIMESTAMPDIFF(SECOND, MIN(_time), MAX(_time)) AS total_seconds
FROM umg801_data;


-- ------------------------------------------------------------
-- 4) Sampling Step Quality (typical time step, duplicates, gaps)
-- ------------------------------------------------------------
WITH sample AS (
    SELECT _time
    FROM umg801_data
    ORDER BY _time
    LIMIT 200000            -- representative sample
),
diffs AS (
    SELECT
        _time,
        LAG(_time) OVER (ORDER BY _time) AS prev_time
    FROM sample
),
steps AS (
    SELECT
        TIMESTAMPDIFF(MICROSECOND, prev_time, _time) / 1000 AS dt_ms
    FROM diffs
    WHERE prev_time IS NOT NULL
)
SELECT
    MIN(dt_ms) AS min_step_ms,
    AVG(dt_ms) AS avg_step_ms,
    MAX(dt_ms) AS max_step_ms,
    SUM(CASE WHEN dt_ms = 0 THEN 1 ELSE 0 END)           AS duplicates_dt_eq_0,
    SUM(CASE WHEN dt_ms > 1000 THEN 1 ELSE 0 END)        AS gaps_dt_gt_1s
FROM steps;


-- ------------------------------------------------------------
-- 5) Dataset Size Indicator – Table size (Data + Index)
-- ------------------------------------------------------------
SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_ROWS,
    DATA_LENGTH  / 1024 / 1024 AS data_mb,
    INDEX_LENGTH / 1024 / 1024 AS index_mb
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'dbsysgr4'
  AND TABLE_NAME   = 'umg801_data';
