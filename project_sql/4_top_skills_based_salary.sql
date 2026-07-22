-- What are the top skills based on salary for my role?
WITH top_skill_based_salary AS(
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
SELECT
    skills_dim.skills,
    AVG(top_skill_based_salary.salary_year_avg) AS Average_Salary
FROM
    top_skill_based_salary
INNER JOIN skills_job_dim ON top_skill_based_salary.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    Average_Salary DESC;