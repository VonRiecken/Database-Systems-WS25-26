-- Load Data

-- 1. Create the table first with the correct structure
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

-- 2. Run the load command
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

-- Count
SELECT COUNT(*) FROM umg801_data LIMIT 0, 1000;

-- Improve and justify your setup for performance (e.g., primary key on `t_stamp`, suitable datatypes, indexing strategy, partitioning if appropriate).
--


-- create a Sandbox table to test sql commands quickly
CREATE TABLE IF NOT EXISTS umg801_sandbox AS
SELECT * FROM umg801_data
LIMIT 10000;
