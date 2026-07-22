-- What are the most in-demand skills for my role?
WITH top_paying_job AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        company_dim.name as Company_Name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
        AND
        job_location = 'Anywhere'
    ORDER BY
        salary_year_avg DESC
)
SELECT
    skills_dim.skills as Skill_Name,
    COUNT(skills_dim.skills) as Skills
FROM
    top_paying_job
LEFT JOIN skills_job_dim ON top_paying_job.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY Skills DESC
LIMIT 10;