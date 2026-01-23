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

USE dbsysgr4;

-- ============================================================
-- 1) Output table (small, report friendly)
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
-- 3) OUTPUTS (report-friendly)
-- ============================================================

-- Monthly totals (table)
SELECT * FROM part4_monthly_totals ORDER BY month_start;

-- Final totals across all months
SELECT
  SUM(n_seconds)      AS total_seconds,
  SUM(consumed_kWh)   AS total_consumed_kWh,
  SUM(produced_kWh)   AS total_produced_kWh
FROM part4_monthly_totals;
