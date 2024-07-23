/*
Question  : What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
1. Identify skills in high demand and associate with high average salaries for Data Analyst roles
2. Concentrates on remote positions with specified salaries
3. Why? Targets skills that offer job security (high demand) and financial benefit (high salaries),
    offering strategic insights for career development in data data analyst
*/


WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim
        ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim
        ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id,
        skills_dim.skills
),
salary_avg AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim
        ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim
        ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN salary_avg
    ON skills_demand.skill_id = salary_avg.skill_id;
