/*
Questions to answer

1. What are the top-paying jobs for my role?
2. What are the skills required for these top-paying roles?
3. What are the most in-demand skills for my role?
4. What are the top skills based on salary for my role?
5. What are the most optimal skills to learn?
    a. High Demand and High Paying
*/

-- job_title_short = 'Data Analyst'
-- average_salary is not Null
-- job_location = 'Anywhere'


-- What are the skills required for these top-paying roles?
WITH top_paying_job AS(
    SELECT
        job_id,
        job_title,
        salary_year_avg
    FROM
        job_postings_fact
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_location = 'Anywhere'
    ORDER BY
        salary_year_avg DESC
)
Select 
    job_title,
    salary_year_avg,
    skills_dim.skills
FROM 
    top_paying_job
INNER JOIN skills_job_dim ON top_paying_job.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;




