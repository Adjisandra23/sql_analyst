/*
Question :
    1. What are the top-paying data analyst jobs?
    2. Identify the top higest-paying Data Analyst roles that are available remotely
    3. Focuses on job postings with specified salaries (remove nulls)
    4. why? Highlight the top-paying opportunities for Data Analysts, offering insights into employee
*/




SELECT
    job_id,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim AS company
    ON company.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;