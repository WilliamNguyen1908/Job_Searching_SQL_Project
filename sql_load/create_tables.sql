-- Schema for the job-market dataset.
-- Column names and order match the CSV files in ../csv_files exactly.
-- Run this BEFORE loading data (load_data.py). Foreign keys are added
-- afterwards (see add_foreign_keys.sql) so the bulk COPY isn't slowed or
-- blocked by constraint checks during the load.

-- Drop children before parents so dependencies resolve.
DROP TABLE IF EXISTS skills_job_dim CASCADE;
DROP TABLE IF EXISTS job_postings_fact CASCADE;
DROP TABLE IF EXISTS company_dim CASCADE;
DROP TABLE IF EXISTS skills_dim CASCADE;

-- Dimension: companies (csv_files/company_dim.csv)
CREATE TABLE company_dim (
    company_id   INTEGER PRIMARY KEY,
    name         VARCHAR,
    link         VARCHAR,
    link_google  VARCHAR,
    thumbnail    VARCHAR
);

-- Dimension: skills (csv_files/skills_dim.csv)
CREATE TABLE skills_dim (
    skill_id  INTEGER PRIMARY KEY,
    skills    VARCHAR,
    type      VARCHAR
);

-- Fact: job postings (csv_files/job_postings_fact.csv)
CREATE TABLE job_postings_fact (
    job_id                 INTEGER PRIMARY KEY,
    company_id             INTEGER,
    job_title_short        VARCHAR,
    job_title              VARCHAR,
    job_location           VARCHAR,
    job_via                VARCHAR,
    job_schedule_type      VARCHAR,
    job_work_from_home     BOOLEAN,
    search_location        VARCHAR,
    job_posted_date        DATE,
    job_no_degree_mention  BOOLEAN,
    job_health_insurance   BOOLEAN,
    job_country            VARCHAR,
    salary_rate            VARCHAR,
    salary_year_avg        DOUBLE PRECISION,
    salary_hour_avg        DOUBLE PRECISION
);

-- Bridge: which skills each job requires (csv_files/skills_job_dim.csv)
CREATE TABLE skills_job_dim (
    job_id    INTEGER,
    skill_id  INTEGER,
    PRIMARY KEY (job_id, skill_id)
);
