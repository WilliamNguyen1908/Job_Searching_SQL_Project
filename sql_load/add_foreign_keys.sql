-- Foreign keys that tie the star schema together.
-- Run this AFTER loading data (load_data.py), because the referenced rows
-- must already exist for the constraints to validate.

ALTER TABLE job_postings_fact
    ADD CONSTRAINT fk_job_company
    FOREIGN KEY (company_id) REFERENCES company_dim (company_id);

ALTER TABLE skills_job_dim
    ADD CONSTRAINT fk_bridge_job
    FOREIGN KEY (job_id) REFERENCES job_postings_fact (job_id);

ALTER TABLE skills_job_dim
    ADD CONSTRAINT fk_bridge_skill
    FOREIGN KEY (skill_id) REFERENCES skills_dim (skill_id);
