# Semester Assignment: Database Systems (MySQL / SQL)
## Big Time Series Data Analysis - Group work

### Rules & Scope
* **Engine:** The entire assignment must be solved purely in **SQL using MySQL 8.x**.
* **Exceptions:** Importing the provided sample data (ZIP/CSV) into MySQL is allowed (e.g., via MySQL Workbench, CLI, or an import script).
* **Dataset:** A medium-size recording (≈ 14.6 million rows) from a Janitza UMG801 power network analyzer, captured via Modbus (timestamp + electrical measurement channels).

---

### Problem 0 – Data Upload & Baseline Analysis
**Goal:** Load the data into MySQL and perform initial performance-oriented schema work.

#### 1. Upload & Row Count
* Import the CSV files from the provided ZIP into a MySQL schema/table.
* **Determine:** How many data rows are contained in the CSV files / final table?

#### 2. Improve Table Setup for Performance
* Create a suitable base table (e.g., `umg801_data`).
* Improve and justify your setup for performance (e.g., primary key on `t_stamp`, suitable datatypes, indexing strategy, partitioning if appropriate).

#### 3. Data-Quality Statistics
Produce at least one meaningful data-quality statistic for the dataset (not an analysis of the electrical values). Acceptable outputs include:
* The recording time range (min/max timestamp, total duration).
* The effective sampling step quality (typical step size, number of duplicates $dt=0$, number of gaps $dt>1s$).
* The coverage of a full second-based timeline (how many seconds have data vs. missing seconds).
* Basic dataset size indicators (row count, approximate table size).

---

### Problem 1 – Data Consistency (Timestamp Integrity)
**Goal:** Detect timestamp defects and compare different second-level timestamp conversions.

#### 1. Defective Intervals
Generate two second-level time series versions:
1.  **Rounded** to seconds.
2.  **Cropped/truncated** to seconds.
* **Determine:** How many defective intervals exist (e.g., $dt \ge 2s$ or $dt = 0$)?

#### 2. Difference: Rounded vs. Cropped Timestamps
* Explain the difference between **rounded** and **cropped** timestamp handling and how it impacts the defect counts.

---

### Problem 2 – Time Mapping (Second-Dimension Table & Join)
**Goal:** Generate a complete second-by-second timestamp table and map the measurements onto it.

#### 1. Efficient Generation of a Second-Level Timestamp Table
* Create a table `ts_seconds(t_sec)` containing every second from `MIN(t_stamp)` to `MAX(t_stamp)` (performance-effective; e.g., day-sized chunks).

#### 2. Mapping into Two Separate Tables
Create two mapped datasets (tables or views):
1.  Mapping using the **cropped** seconds timestamp (`CAST(t_stamp AS DATETIME)`).
2.  Mapping using the **rounded** seconds timestamp.
* Use an **outer join** so that seconds without a measurement remain as rows with `NULL` measurement values.
* Enforce **uniqueness per second** in the join result (e.g., `ROW_NUMBER()` and selecting `rn = 1`).

#### 3. Unlinked / Not Mapped Timestamps
* Compute the number of seconds in `ts_seconds` that have no linked measurement row.
* Explain why this mapping approach differs from the defect detection approach in Problem 1.

---

### Problem 3 – Data Interpolation (Cleaning / Gap Filling)
**Goal:** Create a cleaned second-level dataset by interpolating missing values.

#### 1. Interpolation Query (SELECT)
* Write an interpolation query for **one** chosen data field (e.g., `A_L1`) using surrounding valid samples.

#### 2. Mapped Table as the Base
Create a table `mapped_data` containing:
* The second timestamp key.
* The original measurement values where available.
* `NULL` where missing.

#### 3. Clean Data Table
Create a final clean table (e.g., `clean_data`) with:
* Seconds timestamp as primary key.
* Original values where present.
* Interpolated values where missing.
* Document which fields were interpolated and how.

---

### Problem 4 – Produced vs. Consumed Active Power
* Compute the **consumed** and **produced** (fed back) **active power** from the dataset in SQL (MySQL).

---

### Deliverables
A set of SQL scripts (`.sql`) containing:
* `CREATE TABLE`, `ALTER TABLE`, `INSERT/CTAS`, functions, procedures, etc., and all required `SELECT` queries.
* Clear comments and short justifications for schema and performance choices (keys, indexes, partitioning, mapping logic).
* **A short results summary:** Row counts, number of defective intervals, number of unmapped seconds, and at least one statistic/insight.

**Submission Deadline:** 20.01.2026 23:59h







notes:
- use window functions/partitions - try different time partitions (i.e. weeks, hours, months, etc.)
- indexing - hash / binary tree
- accuracy, no needed for zig dec places
- lock_option
