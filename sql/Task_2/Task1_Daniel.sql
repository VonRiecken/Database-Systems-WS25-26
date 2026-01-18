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
