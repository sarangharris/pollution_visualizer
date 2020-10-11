-- Sarang Harris 
-- sarang.harris@vanderbilt.edu 

-- Create database
DROP DATABASE IF EXISTS air_quality_db;
CREATE DATABASE air_quality_db;
USE air_quality_db;

-- Create table from raw csv file
DROP TABLE IF EXISTS mega_relation;
CREATE TABLE IF NOT EXISTS mega_relation (
	state_code							VARCHAR(5) NOT NULL,
	county_code							SMALLINT(3) UNSIGNED NOT NULL,
	site_num							SMALLINT(4) UNSIGNED NOT NULL,
	parameter_code						MEDIUMINT(5) UNSIGNED NOT NULL,
	poc									TINYINT(2) UNSIGNED NOT NULL,
	latitude							VARCHAR(30),
	longitude							VARCHAR(30),
	datum								VARCHAR(15) NOT NULL,
	parameter_name						VARCHAR(50) NOT NULL,
	sample_duration						VARCHAR(50) NOT NULL,
	pollutant_standard					VARCHAR(50),
	metric_used							VARCHAR(250) NOT NULL,
	method_name							VARCHAR(150),
	year								SMALLINT(4) UNSIGNED NOT NULL,
	units_of_measure					VARCHAR(50) NOT NULL,
	event_type							VARCHAR(50) NOT NULL,
	observation_count					MEDIUMINT(6) UNSIGNED NOT NULL,
	observation_percent					TINYINT(3) UNSIGNED NOT NULL,
	completeness_indicator				VARCHAR(1) NOT NULL,
	valid_day_count						SMALLINT(3) UNSIGNED NOT NULL,
	required_day_count					SMALLINT(3) UNSIGNED NOT NULL,
	exceptional_data_count				MEDIUMINT(5) UNSIGNED NOT NULL,
	null_data_count						SMALLINT(5) UNSIGNED NOT NULL,
	primary_exceedance_count			VARCHAR(10),
	secondary_exceedance_count			VARCHAR(10),
	certification_indicator				VARCHAR(50) NOT NULL,
	num_obs_below_mdl					SMALLINT(1) UNSIGNED NOT NULL,
	arithmetic_mean						VARCHAR(50) NOT NULL,
	arithmetic_standard_dev				VARCHAR(50) NOT NULL,
	first_max_value						VARCHAR(100),
	first_max_datetime					VARCHAR(100),
	second_max_value					VARCHAR(100),
	second_max_datetime					VARCHAR(100),
	third_max_value						VARCHAR(100),
	third_max_datetime					VARCHAR(100),
	fourth_max_value					VARCHAR(100),
	fourth_max_datetime					VARCHAR(100),
	first_max_non_overlapping_value		VARCHAR(20),
	first_no_max_datetime				VARCHAR(50),
	second_max_non_overlapping_value	VARCHAR(20),
	second_no_max_datetime				VARCHAR(50),
	ninety_nine_percentile				FLOAT,
	ninety_eight_percentile				FLOAT,
	ninety_five_percentile				FLOAT,
	ninety_percentile					FLOAT,
	seventy_five_percentile				FLOAT,
	fifty_percentile					FLOAT,
	ten_percentile						FLOAT,
	local_site_name						VARCHAR(255),
	address								VARCHAR(255) NOT NULL,
	state_name							VARCHAR(25) NOT NULL,
	county_name							VARCHAR(100) NOT NULL,
	city_name							VARCHAR(255),
	cbsa_name							VARCHAR(255),
	date_of_last_change					DATE
);
-- make sure you increase the amount of time before timeout 
-- otherwise data won't load
-- DOWNLOAD THE DATA AT: https://www.kaggle.com/epa/air-quality
LOAD DATA INFILE "/Users/sarang/Programming/Projects/Vanderbilt/CS3265/epa_air_quality_annual_summary.csv" INTO TABLE mega_relation 
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;


-- CREATE TABLES IN 3NF
DROP TABLE IF EXISTS ObservationInfo;
CREATE TABLE IF NOT EXISTS ObservationInfo (
    site_num INT UNSIGNED,
	county_code INT UNSIGNED,
	state_code VARCHAR(5),
	parameter_code INT UNSIGNED,
    poc INT UNSIGNED,
    year INT UNSIGNED,
	pollutant_standard VARCHAR(50),
	method_name	VARCHAR(150),
    observation_count MEDIUMINT(6) UNSIGNED NOT NULL,
	event_type VARCHAR(50) NOT NULL,
    sample_duration VARCHAR(50),
    units_of_measure VARCHAR(50) NOT NULL,
    observation_percent TINYINT(3) UNSIGNED NOT NULL,
    completeness_indicator VARCHAR(1) NOT NULL,
    valid_day_count SMALLINT(3) UNSIGNED NOT NULL,
    required_day_count SMALLINT(3) UNSIGNED NOT NULL,
    exceptional_data_count MEDIUMINT(5) UNSIGNED NOT NULL,
    null_data_count SMALLINT(5) UNSIGNED NOT NULL,
    primary_excedence_count VARCHAR(10),
    secondary_excedence_count VARCHAR(10),
    certification_indicator VARCHAR(50) NOT NULL,
    CONSTRAINT pk_oi PRIMARY KEY (parameter_code, poc, year, site_num, county_code, state_code, 
		pollutant_standard, method_name, observation_count, event_type),
	CONSTRAINT uni UNIQUE(site_num, county_code, state_code, 
		pollutant_standard, method_name, observation_count, event_type, parameter_code, poc, year)
);

DROP TABLE IF EXISTS ParameterInfo;
CREATE TABLE IF NOT EXISTS ParameterInfo (
	parameter_code INT UNSIGNED,
    poc INT UNSIGNED,
    parameter_name VARCHAR(50),
    CONSTRAINT pk_pi PRIMARY KEY (parameter_code, poc),
	CONSTRAINT fk_pi FOREIGN KEY (parameter_code, poc) 
	REFERENCES ObservationInfo(parameter_code, poc)
);

DROP TABLE IF EXISTS SiteAddressInfo;
CREATE TABLE IF NOT EXISTS SiteAddressInfo (
    address VARCHAR(250),
	city_name VARCHAR(50), 
	state_name VARCHAR(50), 
	county_name VARCHAR(50),
	local_site_name VARCHAR(150),
    site_num INT UNSIGNED,
	county_code INT UNSIGNED,
	state_code VARCHAR(5),
    CONSTRAINT pk_sa PRIMARY KEY (site_num, county_code, state_code),
    CONSTRAINT uniS UNIQUE(address, local_site_name, site_num, county_code, state_code, city_name, state_name, county_name),
	CONSTRAINT fk_sa FOREIGN KEY (site_num, county_code, state_code) 
	REFERENCES ObservationInfo(site_num, county_code, state_code)
);

DROP TABLE IF EXISTS SiteChanges;
CREATE TABLE IF NOT EXISTS SiteChanges (
    address VARCHAR(250),
	local_site_name VARCHAR(150),
	cbsa_name VARCHAR(50),
	date_of_last_change DATE,
    CONSTRAINT pk_sc PRIMARY KEY (address, local_site_name, cbsa_name),
	CONSTRAINT fk_sc FOREIGN KEY (address, local_site_name) 
	REFERENCES SiteAddressInfo(address, local_site_name)
);

DROP TABLE IF EXISTS StatisticInfo;
CREATE TABLE IF NOT EXISTS StatisticInfo (
    site_num INT UNSIGNED,
	county_code INT UNSIGNED,
	state_code VARCHAR(5),
	parameter_code INT UNSIGNED,
    poc INT UNSIGNED,
    year INT UNSIGNED,
	pollutant_standard VARCHAR(50),
	method_name	VARCHAR(150),
    observation_count MEDIUMINT(6) UNSIGNED NOT NULL,
	event_type VARCHAR(50) NOT NULL,
    parameter_name VARCHAR(50),
    units_of_measure VARCHAR(50) NOT NULL,
	num_obs_below_mdl	SMALLINT(1) UNSIGNED NOT NULL,
	arithmetic_mean	VARCHAR(50) NOT NULL,
	arithmetic_standard_dev	VARCHAR(50) NOT NULL,
	first_max_value	VARCHAR(100),
	first_max_datetime VARCHAR(100),
	second_max_value VARCHAR(100),
	second_max_datetime	VARCHAR(100),
	third_max_value	VARCHAR(100),
	third_max_datetime VARCHAR(100),
	fourth_max_value VARCHAR(100),
	fourth_max_datetime	VARCHAR(100),
	first_max_non_overlapping_value	VARCHAR(20),
	first_no_max_datetime VARCHAR(50),
	second_max_non_overlapping_value VARCHAR(20),
	second_no_max_datetime VARCHAR(50),
	ninety_nine_percentile FLOAT,
	ninety_eight_percentile	FLOAT,
	ninety_five_percentile FLOAT,
	ninety_percentile FLOAT,
	seventy_five_percentile FLOAT,
	fifty_percentile FLOAT,
	ten_percentile FLOAT,
    CONSTRAINT pk_si PRIMARY KEY (parameter_code, poc, year, site_num, county_code, state_code, 
		pollutant_standard, method_name, observation_count, event_type),
	CONSTRAINT fk_si FOREIGN KEY (parameter_code, poc, year, site_num, county_code, state_code, 
		pollutant_standard, method_name, observation_count, event_type) 
	REFERENCES ObservationInfo(parameter_code, poc, year, site_num, county_code, state_code, 
		pollutant_standard, method_name, observation_count, event_type)
);

DROP TABLE IF EXISTS SiteLocation;
CREATE TABLE IF NOT EXISTS SiteLocation (
    site_num INT UNSIGNED,
	county_code INT UNSIGNED,
	state_code VARCHAR(5),
	longitude VARCHAR(50),
    latitude VARCHAR(50),
    CONSTRAINT pk_sl PRIMARY KEY (site_num, county_code, state_code),
    CONSTRAINT uniq UNIQUE(longitude, latitude, site_num, county_code, state_code),
	CONSTRAINT fk_sl FOREIGN KEY (site_num, county_code, state_code) 
	REFERENCES ObservationInfo(site_num, county_code, state_code)
);
    
    
-- INSERT THE DATA into tables from megatable
INSERT INTO ObservationInfo
SELECT site_num, county_code, state_code, parameter_code, poc, year, pollutant_standard, method_name, observation_count,
event_type, sample_duration, units_of_measure, observation_percent, completeness_indicator, valid_day_count, required_day_count, 
exceptional_data_count, null_data_count, primary_exceedance_count, secondary_exceedance_count, certification_indicator
FROM mega_relation;

INSERT INTO ParameterInfo
SELECT parameter_code, poc, parameter_name
FROM mega_relation
GROUP BY parameter_code, poc, parameter_name;

INSERT INTO SiteAddressInfo 
SELECT address, city_name, state_name, county_name, local_site_name, site_num, county_code, state_code
FROM mega_relation
GROUP BY address, city_name, state_name, county_name, local_site_name, site_num, county_code, state_code;

INSERT INTO SiteChanges 
SELECT address, local_site_name, cbsa_name, MAX(date_of_last_change)
FROM mega_relation
GROUP BY address, local_site_name, cbsa_name;

INSERT INTO StatisticInfo
SELECT site_num, county_code, state_code, parameter_code, poc, year, pollutant_standard, method_name,
	observation_count, event_type, parameter_name, units_of_measure, num_obs_below_mdl, arithmetic_mean,
	arithmetic_standard_dev, first_max_value, first_max_datetime, second_max_value, second_max_datetime,
	third_max_value, third_max_datetime, fourth_max_value, fourth_max_datetime, first_max_non_overlapping_value, first_no_max_datetime,
	second_max_non_overlapping_value, second_no_max_datetime, ninety_nine_percentile, ninety_eight_percentile,
	ninety_five_percentile, ninety_percentile, seventy_five_percentile, fifty_percentile, ten_percentile
FROM mega_relation;

INSERT INTO SiteLocation
SELECT site_num, county_code, state_code, longitude, latitude
FROM mega_relation
GROUP BY site_num, county_code, state_code, longitude, latitude;



-- APPLICATION FUNCTIONALITY:

-- INDEXES
-- This index will allow users to quickly translate from state and county codes (which is the primary key)
-- to the written form of city and state names
CREATE INDEX address ON SiteAddressInfo (city_name, state_name);

-- Alternatively, this index allows the application to quickly access latitude and longitude coordinates
-- which can be used to pinpoint the location on Google Maps
CREATE INDEX location ON SiteLocation (latitude, longitude);

-- This index makes finding stats much quicker
CREATE INDEX stats ON StatisticInfo (county_code, state_code, year);


-- STORED PROCEDURES
-- User enters county and state. Returns county code and state code if data exists for that location 
DROP PROCEDURE IF EXISTS locationTranslator;
DELIMITER //
CREATE PROCEDURE locationTranslator(IN countyName VARCHAR(50), IN stateName VARCHAR(50))
BEGIN 
    SELECT county_code, state_code
    FROM SiteAddressInfo
    WHERE county_name = countyName AND state_name = stateName
    GROUP BY county_code, state_code;

END //
DELIMITER ;


-- User enters location and year, will output pollution data 
DROP PROCEDURE IF EXISTS locationYearPollution;
DELIMITER //
CREATE PROCEDURE locationYearPollution(IN countyCode INT, IN stateCode VARCHAR(5), IN yr INT)
BEGIN
	SELECT county_code, state_code, year, parameter_name, units_of_measure, arithmetic_mean, 
			first_max_value, first_max_datetime, seventy_five_percentile
    FROM StatisticInfo
    WHERE county_code = countyCode AND state_code = stateCode AND year = yr;

END //
DELIMITER ;


-- TRIGGERS
-- need to set safe updates to 0 to allow updates in triggers
SET SQL_SAFE_UPDATES = 0;

-- This trigger lets users update the SiteChanges cbsa_name info data but keeps audit record
DROP TABLE IF EXISTS SiteChanges_Audit;
CREATE TABLE SiteChanges_Audit (
	audit_id INT AUTO_INCREMENT,
    address VARCHAR(250),
	local_site_name VARCHAR(150),
	cbsa_name VARCHAR(50),
	date_of_update DATE,
    CONSTRAINT pk_sca PRIMARY KEY (audit_id)
);

DROP TRIGGER IF EXISTS SiteChanges_after_update;
DELIMITER //
CREATE TRIGGER SiteChanges_after_update
AFTER UPDATE
ON SiteChanges
FOR EACH ROW 
BEGIN
INSERT INTO SiteChanges_Audit (address, local_site_name, cbsa_name, date_of_update)
VALUES(OLD.address, OLD.local_site_name, OLD.cbsa_name, NOW());
END //
DELIMITER ;


-- This trigger alloes user to update a parameter name, but keeps a record
DROP TABLE IF EXISTS ParameterInfo_Audit;
CREATE TABLE ParameterInfo_Audit (
	audit_id INT AUTO_INCREMENT,
	parameter_code INT UNSIGNED,
    poc INT UNSIGNED,
    parameter_name VARCHAR(50),
    date_of_update DATE,
    CONSTRAINT pk_pia PRIMARY KEY (audit_id)
);

DROP TRIGGER IF EXISTS ParameterInfo_after_update;
DELIMITER //
CREATE TRIGGER ParameterInfo_after_update
AFTER UPDATE
ON ParameterInfo
FOR EACH ROW 
BEGIN
INSERT INTO ParameterInfo_Audit (parameter_code, poc, parameter_name, date_of_update)
VALUES(OLD.parameter_code, OLD.poc, OLD.parameter_name, NOW());
END //
DELIMITER ;

-- testing that triggers work 
SELECT *
FROM SiteChanges;

SELECT * 
FROM parameterInfo;
