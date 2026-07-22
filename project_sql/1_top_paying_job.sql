/*
Questions: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove nulls)
- Why? Hightlight the top-paying opportunities for Data Analysis, offering insights into employment 
*/

select 
    job_id as id,
    job_title as Title,
    job_location as Locations,
    job_schedule_type as Job_Type,
    salary_year_avg as Average_Salary,
    job_posted_date as Posted_Date,
    company_dim.name as Company_Name
from
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
where 
    job_title_short = 'Data Analyst'
    and job_location = 'Anywhere'
    and salary_year_avg IS NOT NULL
order by
    salary_year_avg DESC
limit 10;



