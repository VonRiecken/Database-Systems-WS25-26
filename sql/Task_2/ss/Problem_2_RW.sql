/* ============================================================
   Problem 2 – Time Mapping (Second-Dimension Table & Join)
   DB:    dbsysgr4
   Table: umg801_sandbox
   Zeitspalte: _time (datetime(3))
   Hilfsspalten: ts_sec_crop, ts_sec_round (datetime)
   ============================================================ */

USE dbsysgr4;

-- ------------------------------------------------------------
-- 0) Sekundenspalten ts_sec_crop / ts_sec_round befüllen
--    (cropped = abgeschnitten, rounded = gerundet)
-- ------------------------------------------------------------
UPDATE umg801_sandbox
SET
  ts_sec_crop  = TIMESTAMP(DATE_FORMAT(_time, '%Y-%m-%d %H:%i:%s')),
  ts_sec_round = FROM_UNIXTIME(ROUND(UNIX_TIMESTAMP(_time)))
WHERE ts_sec_crop IS NULL OR ts_sec_round IS NULL;

-- ------------------------------------------------------------
-- 1) Min/Max-Zeitbereich für die Sekundentabelle bestimmen
-- ------------------------------------------------------------
SELECT
  MIN(ts_sec_crop),
  MAX(ts_sec_crop)
INTO
  @min_sec,
  @max_sec
FROM umg801_sandbox;

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
  FROM umg801_sandbox
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
  FROM umg801_sandbox
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
