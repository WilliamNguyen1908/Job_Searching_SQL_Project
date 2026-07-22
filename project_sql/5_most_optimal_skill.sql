-- What are the most optimal skills to learn?
WITH top_optimal_skills AS(
    SELECT 
        job_id,
        job_title,
        salary_year_avg
    FROM
        job_postings_fact
    where 
        job_title_short = 'Data Analyst' and
        salary_year_avg is not null and 
        job_location = 'Anywhere'
    order by
        salary_year_avg desc
)
select 
    skills_dim.skills,
    count(skills_dim.skills) as Skill_Count,
    avg(top_optimal_skills.salary_year_avg) as Average_Salary
from 
    top_optimal_skills
inner join skills_job_dim on top_optimal_skills.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
group by 
    skills_dim.skills
order by 
    Skill_Count desc,
    Average_Salary DESC;