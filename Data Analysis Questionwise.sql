select * from hr

-- 1. What is the gender breakdown of employees in the company? where age is greater than 18 and currently working employee.


SELECT gender, COUNT(*) as count
FROM hr
WHERE age > 18 AND (termdate IS NULL OR termdate > CURRENT_DATE)
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?

SELECT race, COUNT(*) as count
FROM hr
WHERE age >= 18 AND (termdate IS NULL OR termdate > CURRENT_DATE)
GROUP BY race;

-- 3. What is the age distribution of employees in the company?


SELECT MIN(age) as youngest_age, MAX(age) as oldest_age
FROM hr
WHERE age >= 18 AND (termdate IS NULL OR termdate > CURRENT_DATE);

-- Creating age group.

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+'
  END AS age_group,
  COUNT(*) AS count
FROM hr
WHERE age >= 18 AND (termdate IS NULL OR termdate > CURRENT_DATE)
GROUP BY age_group
ORDER BY age_group;

-- Creating age group by gender.

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+'
  END AS age_group,
  COUNT(*) AS count, gender
FROM hr
WHERE age >= 18 AND (termdate IS NULL OR termdate > CURRENT_DATE)
GROUP BY age_group,gender
ORDER BY age_group,gender;

-- 4. How many employees work at headquarters versus remote locations?


select location, count(*)
from hr
where age >= 18 and (termdate is null or termdate > current_date)
group by location

-- 5. What is the average length of employment for employees who have been terminated?

SELECT round(AVG( (termdate - hiredate) / (365))) || ' years' AS avg_length_of_employment
FROM hr
WHERE termdate IS NOT NULL;

-- 6. How does the gender distribution vary across departments and job titles?

--vary accross department:

select distinct department,gender, count(*)
from hr
where age >= 18 and (termdate is null or termdate > current_date)
group by department, gender
order by department, gender

-- 7. What is the distribution of job titles across the company?

SELECT  jobtitle, COUNT(*) as count
FROM hr
group by jobtitle
order by jobtitle desc

-- 8. Which department has the highest turnover rate?

SELECT
    department,
    total_count,
    terminated_count,
    terminated_count::float / total_count AS termination_rate
FROM (
    SELECT
        department,
        COUNT(*) AS total_count,
        SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURRENT_DATE THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age >= 18
    GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?


select location_state,count(*)
from hr
group by location_state
order by count desc

-- 10. How has the company's employee count changed over time based on hire and term dates?
--(this question demands 'yearwise' distribution of hire, terminations,net change and net change %)


SELECT
    year,
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND((hires - terminations) / hires * 100.0, 2) AS net_change_percent
FROM (
    SELECT
        EXTRACT(YEAR FROM hiredate) AS year,
        COUNT(*) AS hires,
        SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURRENT_DATE THEN 1 ELSE 0 END) AS terminations
    FROM hr
    GROUP BY EXTRACT(YEAR FROM hiredate)
) AS subquery
ORDER BY year;

-- 11. What is the tenure distribution for each department?


SELECT
    department,
   round( AVG(age_years)) AS avg_tenure
FROM (
    SELECT
        department,
        EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hiredate) AS age_years
	FROM hr
) AS subquery
GROUP BY department
ORDER BY department;












