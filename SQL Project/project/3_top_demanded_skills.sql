/*
Question: What are the most in-demand skills for Data Analyst?
1. Join job postings to inner join table similiar to query 2
2. Identify the top 5 in-demand skills for a data analyst
3. Focus on all job postings
4. Why? Retrives the top 5 skills with the highest demand in the jobmarket,
    providing insights into the most valuable skills for a seekers
*/

SELECT
    skills,
    COUNT(skills) AS top_skills_demand
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim
    ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY top_skills_demand DESC
LIMIT 5;