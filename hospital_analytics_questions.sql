-- Connect to database (MySQL only)
USE hospital_db;

-- OBJECTIVE 1: ENCOUNTERS OVERVIEW
-- a. How many total encounters occurred each year?

SELECT YEAR(START) AS year, COUNT(ID) AS total_encounters
FROM encounters
GROUP BY year
ORDER BY year ;

-- b. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?

SELECT year(start) AS year, 
	ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'ambulatory' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS ambulatory,
	ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'outpatient' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS outpatient,
   ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'wellness' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS wellness,
  ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'urgentcare' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS urgent_care,
   ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'emergency' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS emergency,
   ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'inpatient' THEN 1 ELSE 0 END) / COUNT(*) * 100,1) AS inpatient
FROM encounters
GROUP BY year
ORDER BY year;


-- c. What percentage of encounters were over 24 hours versus under 24 hours?
SELECT ROUND(SUM(CASE WHEN TIMESTAMPDIFF(HOUR, START, STOP) >= 24 THEN 1 ELSE 0 END)/COUNT(*) * 100,1) AS over_24_hours, 
  ROUND(SUM(CASE WHEN TIMESTAMPDIFF(HOUR, START, STOP) < 24 THEN 1 ELSE 0 END)/COUNT(*)* 100,1) AS under_24_hours
 FROM encounters;

-- OBJECTIVE 2: COST & COVERAGE INSIGHTS

-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
-- 13586 encounters with zero payer coverage
SELECT COUNT(*)
FROM encounters
WHERE payer_coverage = 0;

-- total encounters 27891
SELECT COUNT(*)
FROM encounters;

-- percentage of ppl with zero coverage
SELECT SUM(CASE WHEN payer_coverage = 0 THEN 1 ELSE 0 END) AS zero_payer_coverage,
COUNT(*) AS total_encounters,
ROUND(SUM(CASE WHEN payer_coverage = 0 THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS pct_zero_payer
FROM encounters;

-- b. What are the top 10 most frequent procedures performed and the average base cost for each?
SELECT *
FROM procedures;

SELECT CODE, DESCRIPTION, COUNT(*) AS num_procedures, AVG(base_cost) AS avg_base_cost
FROM procedures
GROUP BY CODE, DESCRIPTION
ORDER BY num_procedures DESC
LIMIT 10;

-- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?
SELECT CODE, DESCRIPTION, AVG(base_cost) AS avg_base_cost, COUNT(*) AS num_procedures
FROM procedures
GROUP BY CODE, DESCRIPTION
ORDER BY avg_base_cost DESC
LIMIT 10;

-- d. What is the average total claim cost for encounters, broken down by payer?
SELECT * 
FROM encounters; -- payer

SELECT * 
FROM payers; -- id

SELECT p.name, AVG(e.total_claim_cost) AS avg_total_claim_cost
FROM payers p LEFT JOIN encounters e ON p.ID = e.payer
GROUP BY p.name
ORDER BY avg_total_claim_cost DESC; 

-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS
-- Analyze patient behavior

-- a. How many unique patients were admitted each quarter over time?
SELECT*
FROM encounters;

SELECT YEAR(START) AS year, QUARTER(START) AS quarter, COUNT(DISTINCT PATIENT) AS num_unique_patients
FROM encounters
GROUP BY year, quarter
ORDER BY year, quarter;

-- b. How many patients were readmitted within 30 days of a previous encounter?
SELECT PATIENT, START, STOP,
	LEAD(START) OVER(PARTITION BY PATIENT ORDER BY START) AS next_start_date
FROM encounters
ORDER BY PATIENT, START;

WITH cte AS (SELECT PATIENT, START, STOP,
	LEAD(START) OVER(PARTITION BY PATIENT ORDER BY START) AS next_start_date
FROM encounters)

SELECT COUNT(DISTINCT PATIENT) AS num_patients
FROM cte
WHERE DATEDIFF(next_start_date, STOP) <30; -- 771 total patients that readmitted




-- c. Which patients had the most readmissions?
WITH cte AS (SELECT PATIENT, START, STOP,
	LEAD(START) OVER(PARTITION BY PATIENT ORDER BY START) AS next_start_date
FROM encounters)

SELECT PATIENT, COUNT(*) AS num_readmissions
FROM cte
WHERE DATEDIFF(next_start_date, STOP) <30
GROUP BY PATIENT
ORDER BY num_readmissions DESC; 

SELECT *
FROM encounters
WHERE patient = "1712d26d-822d-1e3a-2267-0a9dba31d7c8";


-- What percentage of encounters came from ambulatory, outpatient, and urgent-care services?

-- What percentage of all encounters came from ambulatory,
-- outpatient, and urgent-care services?

SELECT ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'ambulatory' THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS ambulatory, 
ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'outpatient' THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS outpatient, 
ROUND(SUM(CASE WHEN ENCOUNTERCLASS = 'urgentcare' THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS urgent_care,
 ROUND(SUM(CASE WHEN ENCOUNTERCLASS IN ('ambulatory', 'outpatient', 'urgentcare') THEN 1 ELSE 0 END)/COUNT(*)*100,1) AS combined_pct FROM encounters;


-- OBJECTIVE 2: COST & COVERAGE INSIGHTS

-- e. What was the total claim cost for encounters with zero payer coverage,
-- and what percentage of total claim cost does this represent?
-- total claim cost for zero payer coverage: 63.1 million
-- 62% represent of zero payer coverage represents the total claim 
SELECT 
	SUM(CASE WHEN payer_coverage = 0 THEN total_claim_cost ELSE 0 END) AS zero_coverage_claim_cost,
	SUM(total_claim_cost) AS total_claim_cost,
	ROUND(SUM(CASE WHEN payer_coverage = 0 THEN total_claim_cost ELSE 0 END)
		/SUM(total_claim_cost)*100,1) AS pct_zero_coverage_claim_cost
FROM encounters;


-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS

-- d. What percentage of readmissions came from the top 10 patients?
WITH cte AS (
	SELECT PATIENT, START, STOP,
		LEAD(START) OVER(PARTITION BY PATIENT ORDER BY START) AS next_start_date
	FROM encounters
),

patient_readmissions AS (
	SELECT PATIENT, COUNT(*) AS num_readmissions
	FROM cte
	WHERE DATEDIFF(next_start_date, STOP) <30
	GROUP BY PATIENT
),

top_10_patients AS (
	SELECT PATIENT, num_readmissions
	FROM patient_readmissions
	ORDER BY num_readmissions DESC
	LIMIT 10
)

SELECT 
	(SELECT SUM(num_readmissions) FROM top_10_patients) AS top_10_readmissions,
	(SELECT SUM(num_readmissions) FROM patient_readmissions) AS total_readmissions,
	ROUND((SELECT SUM(num_readmissions) FROM top_10_patients)
		/(SELECT SUM(num_readmissions) FROM patient_readmissions)*100,1) AS pct_top_10_readmissions;
