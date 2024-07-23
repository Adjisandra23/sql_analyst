/*
1. Get job details for both 'Data Analyst' or 'Business position'
    - for 'Data Anlayst' i want jobs only > $100k
    - for 'Business Analyst' i want jobs only > $70k
AND only include jobs located in EITHER
    - 'Boston, MA'
    - 'Anywhere'(remote jobs)
*/

SELECT
    job_title_short,
    job_location,
    job_via,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    job_location IN('Boston, MA','Anywhere') AND
    (job_title_short = 'Data Analyst' AND salary_year_avg > 100000 OR
    job_title_short = 'Business Analyst' AND salary_year_avg > 70000)
;




/*
2. Look for non-senior Data Analyst or Business Analyst roles
    - only get job titles that include either 'Data' or 'Business'
    - also include those with 'Analyst' in any part of the title
    - don't include any job titles with 'Senior' followed by any character
    - Get the job title, location, and average yearly salary
*/
SELECT
    job_title,
    job_location AS location,
    salary_year_avg AS salary
FROM
    job_postings_fact
WHERE
    (job_title LIKE '%Data%' OR job_title LIKE '%Business%') AND
    (job_title LIKE '%Analyst%') AND
    (job_title NOT LIKE '%Senior%')
;






/*
3. Write a query to list each unique skill from the ** skills_dim ** table.
    - count how many job postings mention each skill from the ** skills_to_job_dim ** table.
    - group the results by the skill name.
    - Order By the average salary
*/

SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS total_job_posting,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS salary_avg
FROM
    skills_dim
LEFT JOIN skills_job_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
LEFT JOIN job_postings_fact
    ON job_postings_fact.job_id=skills_job_dim.job_id
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY
    salary_avg
;




/*
4. CREATE TABLEFrom Other Tables
- create 3 tables :
    - jan 2023 jobs
    - feb 2023 jobs
    - mar 2023 jobs
*/

CREATE TABLE january_posted AS
    SELECT *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 1
;

CREATE TABLE february_posted AS
    SELECT *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 2
;

CREATE TABLE march_posted AS
    SELECT *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 3
;





/*
5. Find the count of the number of remote job postings per skill
    - display the top 5 skills by their demand in remote jobs
    - include skill ID, Name, and count of postings requiring the skill
*/

WITH skill_job_count AS (
SELECT
    skills_job_dim.skill_id,
    COUNT(*) AS skills_count
FROM
    skills_job_dim
INNER JOIN job_postings_fact
    ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_postings_fact.job_work_from_home = true AND
    job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY
    skills_job_dim.skill_id
)

SELECT
    skill_job_count.skill_id AS ID,
    skills_dim.skills AS name,
    skill_job_count.skills_count
FROM
    skill_job_count
INNER JOIN skills_dim
    ON skills_dim.skill_id = skill_job_count.skill_id
ORDER BY skills_count DESC
LIMIT 5
;




/*
6. Find job postings from the first quarter that have a salary grater than $70k
    - combine job posting tables from the first quarter of 2023(jan-mar)
    - gets job postings with an average yearly salary > $70k
we have been created table jan-march in task 4. so we can use it for this task
*/

SELECT
    job_title_short AS job_title,
    job_location,
    job_via,
    job_country,
    salary_year_avg
FROM (
    SELECT *
    FROM
        january_posted
    UNION ALL
    SELECT *
    FROM
        february_posted
    UNION ALL
    SELECT *
    FROM
        march_posted
) AS first_quarter_job_postings

WHERE
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC
;