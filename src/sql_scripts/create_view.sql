CREATE VIEW vw_covid_cases AS
SELECT
	t1.Country,
	t2.year_week,
	t2.indicator,
	t2.cumulative_count,
	CURRENT_DATE as extraction_date
FROM dell_tests.countries_of_the_world t1 INNER JOIN dell_tests.covid_number_cases t2
ON TRIM(LOWER(t1.Country)) = TRIM(LOWER(t2.country))
WHERE t2.indicator = 'cases' AND t2.year_week = TO_CHAR(current_date-14, 'IYYY-IW')
ORDER BY 4 DESC;