DROP TABLE IF EXISTS dell_tests.covid_number_cases;
CREATE TABLE dell_tests.covid_number_cases (
	country VARCHAR(50),
	country_code VARCHAR(5),
	continent VARCHAR(50),
	population BIGINT,
	indicator VARCHAR(10),
	weekly_count INT,
	year_week VARCHAR(10),
	rate_14_day DECIMAL,
	cumulative_count INT,
	source VARCHAR(100)
);

DROP TABLE IF EXISTS dell_tests.countries_of_the_world;
CREATE TABLE dell_tests.countries_of_the_world (
    Country VARCHAR(100),
	Region VARCHAR(100),
	Population VARCHAR(100),
	Area VARCHAR(100),
	PopDensity VARCHAR(100),
	Coastline VARCHAR(100),
	Netmigration VARCHAR(100),
	Infantmortality VARCHAR(100),
	GDP VARCHAR(100),
	Literacy VARCHAR(100),
	Phones VARCHAR(100),
	Arable VARCHAR(100),
	Crops VARCHAR(100),
	Other VARCHAR(100),
	Climate VARCHAR(100),
	Birthrate VARCHAR(100),
	Deathrate VARCHAR(100),
	Agriculture VARCHAR(100),
	Industry VARCHAR(100),
	Service VARCHAR(100)
);

/*
  Table for data enrichment
*/
DROP TABLE IF EXISTS dell_tests.hospital_occupancy;
CREATE TABLE dell_tests.hospital_occupancy (
	country VARCHAR(50),
	indicator VARCHAR(50),
	date VARCHAR(50),
	year_week VARCHAR(50),
	source VARCHAR(50),
	url VARCHAR(255),
	value VARCHAR(50)
);