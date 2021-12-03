/*
    Query for data enrichment using number of patients to compare the number of cases and hospital occupation
*/
SELECT
	t2.year_week,
	t3.date,
	TRIM(LOWER(t1.Country)),
	ROUND(CAST(t3.value AS DECIMAL)) AS new_hospital_admissions,
	CAST(t2.rate_14_day AS INTEGER) AS number_of_deaths_reported
FROM dell_tests.countries_of_the_world t1 INNER JOIN dell_tests.covid_number_cases t2
	ON TRIM(LOWER(t1.Country)) = TRIM(LOWER(t2.country))
LEFT JOIN dell_tests.hospital_occupancy t3
	ON TRIM(LOWER(t1.Country)) = TRIM(LOWER(t3.country))
	AND CONCAT(DATE_PART('year', CAST(t3.date AS DATE)),'-',DATE_PART('week', CAST(t3.date AS DATE)))  = t2.year_week
WHERE TRIM(LOWER(t2.indicator)) = 'deaths' AND TRIM(LOWER(t1.Country)) = 'italy' AND t3.indicator = 'Weekly new hospital admissions per 100k'
GROUP BY
	t2.year_week,
	t3.date,
	t1.Country,
	t2.rate_14_day,
	t3.value
ORDER BY t2.year_week

/*
    Exercise 4: Queries
    1- What is the country with the highest number of Covid-19 cases per 100 000 Habitants at
    31/07/2020?
*/
SELECT
	country,
	year_week,
	indicator,
	MAX(cumulative_count) as highest_number
FROM dell_tests.covid_number_cases WHERE year_week = TO_CHAR(CAST('2020-07-31' AS DATE), 'IYYY-IW')
AND indicator = 'cases'
AND country NOT LIKE ('%(%')
GROUP BY country, year_week, indicator ORDER BY highest_number DESC;

/*
    Exercise 4: Queries
    2- What is the top 10 countries with the lowest number of Covid-19 cases per 100 000 Habitants at
    31/07/2020?
*/
SELECT DISTINCT
	country,
	year_week,
	indicator,
	MIN(cumulative_count) as highest_number
FROM dell_tests.covid_number_cases WHERE year_week = TO_CHAR(CAST('2020-07-31' AS DATE), 'IYYY-IW')
AND indicator = 'cases'
AND country NOT LIKE ('%(%')
GROUP BY country, year_week, indicator ORDER BY highest_number ASC;

/*
        Exercise 4: Queries
        3- What is the top 10 countries with the highest number of cases among the top 20 richest
        countries (by GDP per capita)?
*/
SELECT * FROM (
	SELECT DISTINCT
		t1.Country,
		SUM(CAST(t2.weekly_count AS INTEGER)) as number_cases,
		CAST(t1.gdp AS INTEGER) AS gdp
	FROM dell_tests.countries_of_the_world t1 INNER JOIN dell_tests.covid_number_cases t2
	ON TRIM(LOWER(t1.Country)) = TRIM(LOWER(t2.country))
	WHERE t2.indicator = 'cases' AND gdp IS NOT NULL
	group by t1.Country,t1.gdp
	ORDER BY gdp DESC
	fetch first 20 rows only
)richest ORDER BY number_cases DESC LIMIT  10;

SELECT *,
	RANK() OVER (ORDER BY number_cases DESC ) AS position
FROM  (
		SELECT
			t1.Country,
			SUM(CAST(t2.weekly_count AS INTEGER)) as number_cases,
			CAST(t1.gdp AS INTEGER) AS gdp
		FROM dell_tests.countries_of_the_world t1 INNER JOIN dell_tests.covid_number_cases t2
		ON TRIM(LOWER(t1.Country)) = TRIM(LOWER(t2.country))
		WHERE t2.indicator = 'cases' AND gdp IS NOT NULL
		group by t1.Country, t1.gdp
		ORDER BY gdp DESC
		fetch first 20 rows only
)topten ORDER BY number_cases DESC LIMIT 10

/*
        Exercise 4: Queries
        4- List all the regions with the number of cases per million of inhabitants and display information
        on population density, for 31/07/2020.
*/
SELECT
	t1.region,
	SUM(CAST(t2.weekly_count AS INTEGER)) AS number_of_cases,
	SUM(CAST(t1.population AS INTEGER)) AS population
FROM dell_tests.countries_of_the_world t1 INNER JOIN dell_tests.covid_number_cases t2
ON TRIM(LOWER(t1.Country)) = TRIM(LOWER(t2.country))
WHERE t2.indicator = 'cases' AND gdp IS NOT NULL
AND t2.year_week = TO_CHAR(CAST('2020-07-31' AS DATE), 'IYYY-IW')
GROUP BY t1.region

/*
        Exercise 4: Queries
        5- Query the data to find duplicated records.
*/
SELECT t2.country, t2.country_code, t2.year_week, t2.indicator, COUNT(*)
FROM dell_tests.countries_of_the_world t1 INNER JOIN dell_tests.covid_number_cases t2
ON TRIM(LOWER(t1.Country)) = TRIM(LOWER(t2.country))
WHERE gdp IS NOT NULL
GROUP BY t2.country, t2.country_code, t2.year_week, t2.indicator HAVING COUNT(*) > 1

