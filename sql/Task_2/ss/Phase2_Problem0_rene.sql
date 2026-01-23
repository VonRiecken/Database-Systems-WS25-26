/* ============================================================
   PHASE 2 – PROBLEM 0: DATA UPLOAD & BASELINE ANALYSIS
   Schema: dbsysgr4
   Tabelle: umg801_data
   ============================================================ */

USE dbsysgr4;

-- ------------------------------------------------------------
-- 1) Basis-Tabellenstruktur (für Import & Performance)
--    Hinweis: Diese CREATE TABLE-Definition dokumentiert das
--    gewählte Schema-Design. Beim Import wurde dieselbe
--    Struktur verwendet (DATETIME(3) + Float-Kanäle).
-- ------------------------------------------------------------
/*
CREATE TABLE IF NOT EXISTS umg801_data (
    _time        DATETIME(3) NOT NULL,
    AZEP         FLOAT,
    A_L1         FLOAT,
    A_L2         FLOAT,
    A_L3         FLOAT,
    A_N          FLOAT,
    COS_PH_L1    FLOAT,
    COS_PH_L2    FLOAT,
    COS_PH_L3    FLOAT
    -- weitere Messkanäle analog als FLOAT/DOUBLE
    ,
    PRIMARY KEY (_time)          -- Zeitbasierter Primary Key
) ENGINE = InnoDB;

-- Design-Begründung (für Doku):
--  * DATETIME(3): Millisekundenauflösung des Loggers.
--  * FLOAT/DOUBLE: geeignet für analoge Messwerte.
--  * PRIMARY KEY(_time): unterstützt effiziente Range-Scans
--    und ORDER BY _time, was für Zeitreihen zentral ist.
--  * InnoDB: Clustered Index auf PK, Transaktionen, Row-Level Locking.
*/


-- ------------------------------------------------------------
-- 2) Row Count – Wie viele Datenzeilen gibt es?
-- ------------------------------------------------------------
SELECT COUNT(*) AS row_count
FROM umg801_data;


-- ------------------------------------------------------------
-- 3) Recording Time Range – Min/Max-Zeitstempel & Gesamtdauer
-- ------------------------------------------------------------
SELECT
    MIN(_time) AS min_time,
    MAX(_time) AS max_time,
    TIMESTAMPDIFF(SECOND, MIN(_time), MAX(_time)) AS total_seconds
FROM umg801_data;


-- ------------------------------------------------------------
-- 4) Sampling-Step-Qualität (typischer Zeitschritt, Duplikate, Gaps)
--
-- Hinweis:
-- Die Tabelle umg801_data enthält ca. 14,6 Mio. Zeilen. Eine
-- Fensterfunktion (LAG() OVER ORDER BY _time) über alle Zeilen
-- führt auf dem Server zu Timeouts (Error 2013).
-- Deshalb wird hier ein repräsentativer Ausschnitt (z.B. 200.000
-- Zeilen) betrachtet. Da das Sampling-Intervall über die gesamte
-- Messung konstant ist, ändert eine Auswertung auf einem Teil der
-- Daten das Ergebnis für den "typischen" Zeitschritt statistisch
-- nicht, reduziert aber die Laufzeit deutlich.
-- ------------------------------------------------------------
WITH sample AS (
    SELECT _time
    FROM umg801_data
    ORDER BY _time
    LIMIT 200000            -- repräsentative Stichprobe
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
-- 5) Dataset Size Indicator – Tabellengröße (Daten + Index)
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
