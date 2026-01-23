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
-- FLOAT chosen because assignment does not require high decimal accuracy.

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
-- -- Column @_measurement is ignored because it contains metadata not required for analysis i.e. only 'umg801'

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
    LIMIT 200000            -- representative sample: sampling used for performance - full dataset yields comparable statistics

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


-- ============================================================
-- Problem 1: Detect timestamp defects at second resolution
-- Dataset: umg801_data
-- Original timestamp column: _time
-- Goal:
--   1) Create two second-level timestamps:
--        - cropped (truncated)
--        - rounded
--   2) Detect defective intervals:
--        - dt = 0   (duplicate seconds)
--        - dt >= 2  (missing seconds / gaps)
-- ============================================================


-- ------------------------------------------------------------
-- Step 1: Extend table with second-level timestamp columns
-- These are stored explicitly (not GENERATED columns),
-- because MySQL does not allow time conversion functions
-- inside GENERATED ALWAYS AS expressions.
-- ------------------------------------------------------------
ALTER TABLE umg801_data
  ADD COLUMN ts_sec_crop  DATETIME(0),   -- cropped / truncated to full seconds
  ADD COLUMN ts_sec_round DATETIME(0);   -- rounded to nearest second


-- ------------------------------------------------------------
-- Step 2: Fill second-level timestamps
--
-- ts_sec_crop:
--   - truncates fractional seconds
--
-- ts_sec_round:
--   - adds 0.5 seconds (500000 µs) before truncation
-- ------------------------------------------------------------
UPDATE umg801_data
SET
  ts_sec_crop  = DATE_FORMAT(_time, '%Y-%m-%d %H:%i:%s'),
  ts_sec_round = DATE_FORMAT(
                   DATE_ADD(_time, INTERVAL 500000 MICROSECOND),
                   '%Y-%m-%d %H:%i:%s'
                 );


-- ------------------------------------------------------------
-- Step 3: Create indexes on the derived timestamp columns
-- These indexes are crucial for performance when ordering
-- large datasets (~14.6 million rows) and using window functions.
-- ------------------------------------------------------------
ALTER TABLE umg801_data
  ADD INDEX idx_ts_sec_crop  (ts_sec_crop),
  ADD INDEX idx_ts_sec_round (ts_sec_round);


-- ------------------------------------------------------------
-- Step 4: Sanity check
-- Display a few rows to verify cropped vs. rounded timestamps.
-- Used only for validation, not for analysis.
-- ------------------------------------------------------------
SELECT
  _time,
  DATE_FORMAT(_time, '%Y-%m-%d %H:%i:%s') AS ts_sec_crop,
  DATE_FORMAT(
    DATE_ADD(_time, INTERVAL 500000 MICROSECOND),
    '%Y-%m-%d %H:%i:%s'
  ) AS ts_sec_round
FROM umg801_data
LIMIT 10;


-- ------------------------------------------------------------
-- Step 5a: Detect defective intervals using CROPPED timestamps
--
-- LAG() retrieves the previous timestamp in time order.
-- TIMESTAMPDIFF is used to compute dt between consecutive rows.
--
-- Defects:
--   dt = 0  → multiple measurements mapped to same second
--   dt >= 2 → missing seconds (gaps in time series)
-- ------------------------------------------------------------
WITH s AS (
  SELECT
    ts_sec_crop AS ts,
    LAG(ts_sec_crop) OVER (ORDER BY ts_sec_crop) AS prev_ts
  FROM umg801_data
  WHERE ts_sec_crop IS NOT NULL
)
SELECT
  COUNT(*) AS intervals_total,                  -- number of evaluated intervals
  SUM(prev_ts IS NULL) AS first_row,             -- first row (no previous value)
  SUM(prev_ts IS NOT NULL
      AND TIMESTAMPDIFF(SECOND, prev_ts, ts) = 0) AS dt_eq_0,
  SUM(prev_ts IS NOT NULL
      AND TIMESTAMPDIFF(SECOND, prev_ts, ts) >= 2) AS dt_ge_2,
  SUM(prev_ts IS NOT NULL
      AND (TIMESTAMPDIFF(SECOND, prev_ts, ts) = 0
        OR TIMESTAMPDIFF(SECOND, prev_ts, ts) >= 2)) AS defects_total
FROM s;


-- ------------------------------------------------------------
-- Step 5b: Detect defective intervals using ROUNDED timestamps
-- Same logic as above, but applied to ts_sec_round.
-- ------------------------------------------------------------
WITH s AS (
  SELECT
    ts_sec_round AS ts,
    LAG(ts_sec_round) OVER (ORDER BY ts_sec_round) AS prev_ts
  FROM umg801_data
  WHERE ts_sec_round IS NOT NULL
)
SELECT
  COUNT(*) AS intervals_total,
  SUM(prev_ts IS NULL) AS first_row,
  SUM(prev_ts IS NOT NULL
      AND TIMESTAMPDIFF(SECOND, prev_ts, ts) = 0) AS dt_eq_0,
  SUM(prev_ts IS NOT NULL
      AND TIMESTAMPDIFF(SECOND, prev_ts, ts) >= 2) AS dt_ge_2,
  SUM(prev_ts IS NOT NULL
      AND (TIMESTAMPDIFF(SECOND, prev_ts, ts) = 0
        OR TIMESTAMPDIFF(SECOND, prev_ts, ts) >= 2)) AS defects_total
FROM s;


-- ------------------------------------------------------------
-- Step 6: Direct comparison of cropped vs. rounded timestamps
--
-- Both time series are stacked using UNION ALL.
-- PARTITION BY ensures that LAG() is computed independently
-- for each timestamp handling method.
-- ------------------------------------------------------------
WITH base AS (
  SELECT ts_sec_crop AS ts, 'crop' AS mode
  FROM umg801_data
  WHERE ts_sec_crop IS NOT NULL

  UNION ALL

  SELECT ts_sec_round AS ts, 'round' AS mode
  FROM umg801_data
  WHERE ts_sec_round IS NOT NULL
),
s AS (
  SELECT
    mode,
    ts,
    LAG(ts) OVER (PARTITION BY mode ORDER BY ts) AS prev_ts
  FROM base
)
SELECT
  mode,                                          -- crop vs. round
  COUNT(*) AS intervals_total,
  SUM(prev_ts IS NOT NULL
      AND TIMESTAMPDIFF(SECOND, prev_ts, ts) = 0)  AS dt_eq_0,
  SUM(prev_ts IS NOT NULL
      AND TIMESTAMPDIFF(SECOND, prev_ts, ts) >= 2) AS dt_ge_2,
  SUM(prev_ts IS NOT NULL
      AND (TIMESTAMPDIFF(SECOND, prev_ts, ts) = 0
        OR TIMESTAMPDIFF(SECOND, prev_ts, ts) >= 2)) AS defects_total
FROM s
GROUP BY mode;

-- Rounding can shift measurements across second boundaries
-- Cropping preserves causality but increases duplicates

/* ============================================================
   Problem 2 – Time Mapping (Second-Dimension Table & Join)
   DB:    dbsysgr4
   Table: umg801_sandbox
   Zeitspalte: _time (datetime(3))
   Hilfsspalten: ts_sec_crop, ts_sec_round (datetime)
   ============================================================ */

-- ------------------------------------------------------------
-- 1) Min/Max-Zeitbereich für die Sekundentabelle bestimmen
-- ------------------------------------------------------------
SELECT
  MIN(ts_sec_crop),
  MAX(ts_sec_crop)
INTO
  @min_sec,
  @max_sec
FROM umg801_data;

-- ------------------------------------------------------------
-- 2) Hilfstabelle: Sekunden 0..86399 (alle Sekunden eines Tages)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS seq_0_86399;
CREATE TABLE seq_0_86399 (
  n INT NOT NULL,
  PRIMARY KEY (n)
) ENGINE=InnoDB;

INSERT INTO seq_0_86399 (n)
WITH RECURSIVE r AS (
  SELECT 0 AS n
  UNION ALL
  SELECT n + 1 FROM r WHERE n < 86399
)
SELECT n FROM r;
-- recursive functions were implemented here to generate a continuous, gap-free reference timeline (Master Time Table).
-- recursion allows the database to programmatically construct a complete sequence of 86,400 seconds per day.

-- ------------------------------------------------------------
-- 3) Hilfstabelle: Alle Tage im betrachteten Zeitraum
-- ------------------------------------------------------------
DROP TABLE IF EXISTS ts_days;
CREATE TABLE ts_days (
  d DATE NOT NULL,
  PRIMARY KEY (d)
) ENGINE=InnoDB;

INSERT INTO ts_days (d)
WITH RECURSIVE days AS (
  SELECT DATE(@min_sec) AS d
  UNION ALL
  SELECT DATE_ADD(d, INTERVAL 1 DAY) FROM days WHERE d < DATE(@max_sec)
)
SELECT d FROM days;

-- ------------------------------------------------------------
-- 4) ts_seconds: komplette Sekundentabelle
--    -> Jede Sekunde zwischen @min_sec und @max_sec
-- ------------------------------------------------------------
DROP TABLE IF EXISTS ts_seconds;
CREATE TABLE ts_seconds (
  t_sec DATETIME NOT NULL,
  PRIMARY KEY (t_sec)
) ENGINE=InnoDB;

INSERT INTO ts_seconds (t_sec)
SELECT
  TIMESTAMP(d.d) + INTERVAL s.n SECOND AS t_sec
FROM ts_days d
JOIN seq_0_86399 s
WHERE (TIMESTAMP(d.d) + INTERVAL s.n SECOND) BETWEEN @min_sec AND @max_sec;

-- ------------------------------------------------------------
-- 5) mapped_crop: Mapping mit CROPPED Sekunden
--    - dedup: pro Sekunde nur eine Messung (ROW_NUMBER)
--    - LEFT JOIN: alle Sekunden bleiben erhalten
-- ------------------------------------------------------------
DROP TABLE IF EXISTS mapped_crop;

CREATE TABLE mapped_crop AS
WITH dedup AS (
  SELECT
    ts_sec_crop AS t_sec,     -- Sekunde (cropped)
    _time       AS meas_time, -- originaler Zeitstempel
    AZEP,
    A_L1,
    A_L2,
    A_L3,
    A_N,
    COS_PHI_L1,
    COS_PHI_L2,
    COS_PHI_L3,
    THDI_L1,
    THDI_L2,
    THDI_L3,
    THDU_L1N,
    THDU_L2N,
    THDU_L3N,
    V_L1_L2,
    V_L1_N,
    V_L2_L3,
    V_L2_N,
    V_L3_L1,
    V_L3_N,
    ROW_NUMBER() OVER (
      PARTITION BY ts_sec_crop      -- pro Sekunde
      ORDER BY _time ASC            -- älteste Messung zuerst
    ) AS rn
  FROM umg801_data
)
SELECT
  s.t_sec,         -- jede Sekunde aus ts_seconds
  dd.meas_time,    -- Messzeit (NULL, wenn keine Messung)
  dd.AZEP,
  dd.A_L1,
  dd.A_L2,
  dd.A_L3,
  dd.A_N,
  dd.COS_PHI_L1,
  dd.COS_PHI_L2,
  dd.COS_PHI_L3,
  dd.THDI_L1,
  dd.THDI_L2,
  dd.THDI_L3,
  dd.THDU_L1N,
  dd.THDU_L2N,
  dd.THDU_L3N,
  dd.V_L1_L2,
  dd.V_L1_N,
  dd.V_L2_L3,
  dd.V_L2_N,
  dd.V_L3_L1,
  dd.V_L3_N
FROM ts_seconds s
LEFT JOIN (         -- OUTER JOIN: alle Sekunden bleiben da
  SELECT *
  FROM dedup
  WHERE rn = 1      -- genau eine Messung pro Sekunde
) AS dd
  ON dd.t_sec = s.t_sec;

-- Optional: Index auf t_sec für schnellere Abfragen
-- ALTER TABLE mapped_crop ADD INDEX idx_mapped_crop_tsec (t_sec);

-- ------------------------------------------------------------
-- 6) mapped_round: Mapping mit GERUNDETEN Sekunden
--    gleiche Logik, nur ts_sec_round statt ts_sec_crop
-- ------------------------------------------------------------
DROP TABLE IF EXISTS mapped_round;

CREATE TABLE mapped_round AS
WITH dedup AS (
  SELECT
    ts_sec_round AS t_sec,    -- Sekunde (rounded)
    _time        AS meas_time,
    AZEP,
    A_L1,
    A_L2,
    A_L3,
    A_N,
    COS_PHI_L1,
    COS_PHI_L2,
    COS_PHI_L3,
    THDI_L1,
    THDI_L2,
    THDI_L3,
    THDU_L1N,
    THDU_L2N,
    THDU_L3N,
    V_L1_L2,
    V_L1_N,
    V_L2_L3,
    V_L2_N,
    V_L3_L1,
    V_L3_N,
    ROW_NUMBER() OVER (
      PARTITION BY ts_sec_round
      ORDER BY _time ASC
    ) AS rn
  FROM umg801_data
)
SELECT
  s.t_sec,
  dd.meas_time,
  dd.AZEP,
  dd.A_L1,
  dd.A_L2,
  dd.A_L3,
  dd.A_N,
  dd.COS_PHI_L1,
  dd.COS_PHI_L2,
  dd.COS_PHI_L3,
  dd.THDI_L1,
  dd.THDI_L2,
  dd.THDI_L3,
  dd.THDU_L1N,
  dd.THDU_L2N,
  dd.THDU_L3N,
  dd.V_L1_L2,
  dd.V_L1_N,
  dd.V_L2_L3,
  dd.V_L2_N,
  dd.V_L3_L1,
  dd.V_L3_N
FROM ts_seconds s
LEFT JOIN (
  SELECT *
  FROM dedup
  WHERE rn = 1
) AS dd
  ON dd.t_sec = s.t_sec;

-- Optional: Index auf t_sec
-- ALTER TABLE mapped_round ADD INDEX idx_mapped_round_tsec (t_sec);

-- ------------------------------------------------------------
-- 7) Kennzahlen für Problem 2
-- ------------------------------------------------------------

-- Gesamtanzahl Sekunden im Zeitbereich
SELECT COUNT(*) AS total_seconds_in_timeline
FROM ts_seconds;

-- Sekunden ohne Messung (Cropping)
SELECT COUNT(*) AS unmapped_seconds_crop
FROM mapped_crop
WHERE meas_time IS NULL;

-- Sekunden ohne Messung (Rounding)
SELECT COUNT(*) AS unmapped_seconds_round
FROM mapped_round
WHERE meas_time IS NULL;

-- Kleine Checks (optional)
SELECT MIN(t_sec) AS min_tsec, MAX(t_sec) AS max_tsec FROM ts_seconds;
SELECT COUNT(*) AS rows_mapped_crop  FROM mapped_crop;
SELECT COUNT(*) AS rows_mapped_round FROM mapped_round;

-- Mapping checks coverage, whilst defect detection checks measurement continuity.

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
-- note that if prev_t or next_t is NULL (start/end), interpolation produces NULL

-- add primary key to link to original data
ALTER TABLE cleaned_A_L1_data ADD PRIMARY KEY (t_sec);

select * from cleaned_A_L1_data
-- where is_interpolated = 1
LIMIT 10000;

-- Fields interpolated "azep"
-- Linear interpolation was used to fill temporal gaps. The formula applied was $y = y_1 + (y_2 - y_1) \cdot \frac{t - t_1}{t_2 - t_1}$,
-- where $t$ represents the target timestamp, and indices 1 and 2 represent the nearest preceding and following valid measurements.

/* ============================================================
   Problem 4 — Produced vs Consumed Active Power (FAST)

   Table: umg801_data (partitioned by _time)
   PRIMARY KEY: _time  -> already indexed

   Key idea:
   - Partition pruning: always filter on _time month-by-month
   - Per-second grouping WITHOUT generated columns:
       sec_key = UNIX_TIMESTAMP(_time)
     (drops milliseconds automatically)

   Active power (W):
     P_total = Σ( V_Lx_N * A_Lx * COS_PHI_Lx )

   consumed_W = max(P_total, 0)
   produced_W = max(-P_total, 0)

   Energy:
     kWh = SUM(P[W]) / 3,600,000    (1-second resolution)
   ============================================================ */

-- ============================================================
-- 1) Output table
-- ============================================================
DROP TABLE IF EXISTS part4_monthly_totals;

CREATE TABLE part4_monthly_totals (
  month_start DATE PRIMARY KEY,
  n_seconds BIGINT,
  consumed_kWh DOUBLE,
  produced_kWh DOUBLE
);

-- ============================================================
-- 2) Month-by-month inserts (each scans ONLY one partition)
-- ============================================================

-- -------- 2025-07
INSERT INTO part4_monthly_totals
SELECT
  DATE('2025-07-01') AS month_start,
  COUNT(*) AS n_seconds, -- averaging within each second compensates for multiple samples per second.
  SUM(consumed_W) / 3600000 AS consumed_kWh,
  SUM(produced_W) / 3600000 AS produced_kWh
FROM (
  SELECT
    UNIX_TIMESTAMP(_time) AS sec_key,

    AVG(GREATEST(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0),
      0
    )) AS consumed_W,

    AVG(GREATEST(-(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0)
    ), 0)) AS produced_W

  FROM umg801_data
  WHERE _time >= '2025-07-01' AND _time < '2025-08-01'
  GROUP BY sec_key
) s;


-- -------- 2025-08
INSERT INTO part4_monthly_totals
SELECT
  DATE('2025-08-01') AS month_start,
  COUNT(*) AS n_seconds,
  SUM(consumed_W) / 3600000 AS consumed_kWh,
  SUM(produced_W) / 3600000 AS produced_kWh
FROM (
  SELECT
    UNIX_TIMESTAMP(_time) AS sec_key,
    AVG(GREATEST(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0),
      0
    )) AS consumed_W,
    AVG(GREATEST(-(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0)
    ), 0)) AS produced_W
  FROM umg801_data
  WHERE _time >= '2025-08-01' AND _time < '2025-09-01'
  GROUP BY sec_key
) s;


-- -------- 2025-09
INSERT INTO part4_monthly_totals
SELECT
  DATE('2025-09-01') AS month_start,
  COUNT(*) AS n_seconds,
  SUM(consumed_W) / 3600000 AS consumed_kWh,
  SUM(produced_W) / 3600000 AS produced_kWh
FROM (
  SELECT
    UNIX_TIMESTAMP(_time) AS sec_key,
    AVG(GREATEST(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0),
      0
    )) AS consumed_W,
    AVG(GREATEST(-(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0)
    ), 0)) AS produced_W
  FROM umg801_data
  WHERE _time >= '2025-09-01' AND _time < '2025-10-01'
  GROUP BY sec_key
) s;


-- -------- 2025-10
INSERT INTO part4_monthly_totals
SELECT
  DATE('2025-10-01') AS month_start,
  COUNT(*) AS n_seconds,
  SUM(consumed_W) / 3600000 AS consumed_kWh,
  SUM(produced_W) / 3600000 AS produced_kWh
FROM (
  SELECT
    UNIX_TIMESTAMP(_time) AS sec_key,
    AVG(GREATEST(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0),
      0
    )) AS consumed_W,
    AVG(GREATEST(-(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0)
    ), 0)) AS produced_W
  FROM umg801_data
  WHERE _time >= '2025-10-01' AND _time < '2025-11-01'
  GROUP BY sec_key
) s;


-- -------- 2025-11
INSERT INTO part4_monthly_totals
SELECT
  DATE('2025-11-01') AS month_start,
  COUNT(*) AS n_seconds,
  SUM(consumed_W) / 3600000 AS consumed_kWh,
  SUM(produced_W) / 3600000 AS produced_kWh
FROM (
  SELECT
    UNIX_TIMESTAMP(_time) AS sec_key,
    AVG(GREATEST(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0),
      0
    )) AS consumed_W,
    AVG(GREATEST(-(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0)
    ), 0)) AS produced_W
  FROM umg801_data
  WHERE _time >= '2025-11-01' AND _time < '2025-12-01'
  GROUP BY sec_key
) s;


-- -------- 2025-12
INSERT INTO part4_monthly_totals
SELECT
  DATE('2025-12-01') AS month_start,
  COUNT(*) AS n_seconds,
  SUM(consumed_W) / 3600000 AS consumed_kWh,
  SUM(produced_W) / 3600000 AS produced_kWh
FROM (
  SELECT
    UNIX_TIMESTAMP(_time) AS sec_key,
    AVG(GREATEST(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0),
      0
    )) AS consumed_W,
    AVG(GREATEST(-(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0)
    ), 0)) AS produced_W
  FROM umg801_data
  WHERE _time >= '2025-12-01' AND _time < '2026-01-01'
  GROUP BY sec_key
) s;


-- -------- 2026-01
INSERT INTO part4_monthly_totals
SELECT
  DATE('2026-01-01') AS month_start,
  COUNT(*) AS n_seconds,
  SUM(consumed_W) / 3600000 AS consumed_kWh,
  SUM(produced_W) / 3600000 AS produced_kWh
FROM (
  SELECT
    UNIX_TIMESTAMP(_time) AS sec_key,
    AVG(GREATEST(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0),
      0
    )) AS consumed_W,
    AVG(GREATEST(-(
      COALESCE(V_L1_N,0)*COALESCE(A_L1,0)*COALESCE(COS_PHI_L1,0) +
      COALESCE(V_L2_N,0)*COALESCE(A_L2,0)*COALESCE(COS_PHI_L2,0) +
      COALESCE(V_L3_N,0)*COALESCE(A_L3,0)*COALESCE(COS_PHI_L3,0)
    ), 0)) AS produced_W
  FROM umg801_data
  WHERE _time >= '2026-01-01' AND _time < '2026-02-01'
  GROUP BY sec_key
) s;


-- ============================================================
-- 3) OUTPUTS
-- ============================================================

-- Monthly totals (table)
SELECT * FROM part4_monthly_totals ORDER BY month_start;

-- Final totals across all months
SELECT
  SUM(n_seconds)      AS total_seconds,
  SUM(consumed_kWh)   AS total_consumed_kWh,
  SUM(produced_kWh)   AS total_produced_kWh
FROM part4_monthly_totals;


/* ============================================================
   Final Results Summary View
   Covers:
   - Row count
   - Recording time range
   - Timestamp defects (crop vs round)
   - Unmapped seconds
   - Total consumed & produced energy
   ============================================================ */

CREATE OR REPLACE VIEW v_umg801_results_summary AS
WITH
-- ------------------------------------------------------------
-- 1) Basic dataset stats
-- ------------------------------------------------------------
base_stats AS (
    SELECT
        COUNT(*)                         AS total_rows,
        MIN(_time)                       AS min_time,
        MAX(_time)                       AS max_time,
        TIMESTAMPDIFF(SECOND,
            MIN(_time), MAX(_time)
        )                                AS total_duration_seconds
    FROM umg801_data
),

-- ------------------------------------------------------------
-- 2) Timestamp defects (cropped)
-- ------------------------------------------------------------
crop_defects AS (
    SELECT
        SUM(dt = 0)   AS crop_dt_eq_0,
        SUM(dt >= 2)  AS crop_dt_ge_2
    FROM (
        SELECT
            TIMESTAMPDIFF(
                SECOND,
                LAG(ts_sec_crop) OVER (ORDER BY ts_sec_crop),
                ts_sec_crop
            ) AS dt
        FROM umg801_data
        WHERE ts_sec_crop IS NOT NULL
    ) x
),

-- ------------------------------------------------------------
-- 3) Timestamp defects (rounded)
-- ------------------------------------------------------------
round_defects AS (
    SELECT
        SUM(dt = 0)   AS round_dt_eq_0,
        SUM(dt >= 2)  AS round_dt_ge_2
    FROM (
        SELECT
            TIMESTAMPDIFF(
                SECOND,
                LAG(ts_sec_round) OVER (ORDER BY ts_sec_round),
                ts_sec_round
            ) AS dt
        FROM umg801_data
        WHERE ts_sec_round IS NOT NULL
    ) x
),

-- ------------------------------------------------------------
-- 4) Mapping coverage
-- ------------------------------------------------------------
mapping_stats AS (
    SELECT
        (SELECT COUNT(*) FROM ts_seconds)                             AS total_seconds,
        (SELECT COUNT(*) FROM mapped_crop  WHERE meas_time IS NULL)   AS unmapped_crop_seconds,
        (SELECT COUNT(*) FROM mapped_round WHERE meas_time IS NULL)   AS unmapped_round_seconds
),

-- ------------------------------------------------------------
-- 5) Energy totals
-- ------------------------------------------------------------
energy_totals AS (
    SELECT
        SUM(consumed_kWh) AS total_consumed_kWh,
        SUM(produced_kWh) AS total_produced_kWh
    FROM part4_monthly_totals
)

-- ------------------------------------------------------------
-- Final projection
-- ------------------------------------------------------------
SELECT
    b.total_rows,
    b.min_time,
    b.max_time,
    b.total_duration_seconds,

    c.crop_dt_eq_0,
    c.crop_dt_ge_2,

    r.round_dt_eq_0,
    r.round_dt_ge_2,

    m.total_seconds,
    m.unmapped_crop_seconds,
    m.unmapped_round_seconds,

    e.total_consumed_kWh,
    e.total_produced_kWh
FROM base_stats b
CROSS JOIN crop_defects c
CROSS JOIN round_defects r
CROSS JOIN mapping_stats m
CROSS JOIN energy_totals e;

-- View the view:
SELECT * FROM v_umg801_results_summary;
