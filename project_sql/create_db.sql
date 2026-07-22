CREATE TABLE IF NOT EXISTS job_postings_fact (
    job_id INTEGER PRIMARY KEY,
    company_id INTEGER,
    job_title_short VARCHAR(255),
    job_title VARCHAR(255),
    job_location VARCHAR(255),
    job_via VARCHAR(255),
    job_schedule_type VARCHAR(255),
    job_work_from_home BOOLEAN,
    search_location VARCHAR(255),
    job_posted_date DATE,
    job_no_degree_mention BOOLEAN,
    job_health_insurance BOOLEAN,
    job_country VARCHAR(255),
    salary_rate VARCHAR(255),
    salary_year_avg FLOAT,
    salary_hour_avg FLOAT
);

CREATE TABLE IF NOT EXISTS company_dim (
    company_id INTEGER PRIMARY KEY,
    company_name VARCHAR(255),
    company_location VARCHAR(255),
    company_size VARCHAR(255),
    company_industry VARCHAR(255),
    company_founded_year INTEGER
);

CREATE TABLE IF NOT EXISTS job_title_dim (
    job_title_id INTEGER PRIMARY KEY,
    job_title VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS job_location_dim (
    job_location_id INTEGER PRIMARY KEY,
    job_location VARCHAR(255)
);