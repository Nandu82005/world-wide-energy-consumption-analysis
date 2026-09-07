-- =====================================================
-- SQL PROJECT: WORLD WIDE ENERGY CONSUMPTION
-- Database: ENERGYDB2
-- =====================================================

-- =====================================================
--  CREATE DATABASE
-- =====================================================
CREATE DATABASE ENERGYDB2;
USE ENERGYDB2;

-- =====================================================
-- 1. COUNTRY TABLE
-- =====================================================
CREATE TABLE country (
    CID VARCHAR(10) PRIMARY KEY,
    Country VARCHAR(100) UNIQUE
);
SELECT * FROM country;
SELECT COUNT(*) FROM country;
 /* --> the country table contain 230 records */

-- =====================================================
-- 2. EMISSION TABLE
-- =====================================================

CREATE TABLE emission (
    country VARCHAR(100),
    energy_type VARCHAR(50),
    year INT,
    emission INT,
    per_capita_emission DOUBLE
);
SELECT * FROM emission;
SELECT COUNT(*) FROM emission;
/* in the emission table there are 3515 records it contains*/
-- =====================================================
-- 3. POPULATION TABLE
-- =====================================================
CREATE TABLE population (
    countries VARCHAR(100),
    year INT,
    Value DOUBLE
);
SELECT * FROM population;
SELECT COUNT(*) FROM population;
/* the population table contains 1000 records */
-- =====================================================
-- 4. PRODUCTION TABLE
-- =====================================================
CREATE TABLE production (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    production INT
);
SELECT * FROM production;
SELECT COUNT(*) FROM production;
/* the production table contain 5294 record */
-- =====================================================
-- 5. GDP TABLE
-- =====================================================

CREATE TABLE gdp(
    Country VARCHAR(100),
    year INT,
    Value DOUBLE
);
SELECT * FROM gdp;
SELECT COUNT(*) FROM gdp;
/* the gdp table contains 1000 records */
-- =====================================================
-- 6. CONSUMPTION TABLE
-- =====================================================
CREATE TABLE consumption (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    consumption INT
);
SELECT * FROM consumption;
SELECT COUNT(*) FROM consumption;
/* consumption table contain 5277 records */
-- =====================================================
-- CHECK ALL TABLES
-- =====================================================
SHOW TABLES;

--  =====================================================
-- RELATIONSHIPS
-- =====================================================
/* -- country → (many)emission*/

ALTER TABLE emission
ADD CONSTRAINT fk_emission_country
FOREIGN KEY (country)
REFERENCES country(Country);
/*
-- The country column in emission references the Country column in the country table.
-- This creates a one-to-many relationship because one country can have multiple emission records.
*/

/* -- country → (many) population */
ALTER TABLE population
ADD CONSTRAINT fk_population_country
FOREIGN KEY (countries)
REFERENCES country(Country);
/*
-- The countries column in population references the Country column in the country table.
-- This creates a one-to-many relationship because one country can have multiple population records.
*/

/* -- country → (many) production */

ALTER TABLE production
ADD CONSTRAINT fk_production_country
FOREIGN KEY (country)
REFERENCES country(Country);
/*
-- The country column in production references the Country column in the country table.
-- This creates a one-to-many relationship because one country can have multiple production records.
*/

/* -- country → (many) consumption */

ALTER TABLE consumption
ADD CONSTRAINT fk_consumption_country
FOREIGN KEY (country)
REFERENCES country(Country);

/*
-- The country column in consumption references the Country column in the country table.
-- This creates a one-to-many relationship because one country can have multiple consumption records.
*/

/* -- country → (many) gdp */

ALTER TABLE gdp
ADD CONSTRAINT fk_gdp_country
FOREIGN KEY (Country)
REFERENCES country(Country);

/*
-- The Country column in gdp references the Country column in the country table.
-- This creates a one-to-many relationship because one country can have multiple GDP records.
*/



-- =====================================================
-- DATA ANALYSIS
-- GENERAL & COMPARATIVE ANALYSIS
-- =====================================================


-- Q1. What is the total emission per country  for the most recent year available?

SELECT
    country,
    year,
    SUM(emission) AS total_emission
FROM emission
WHERE year = (SELECT MAX(year) FROM emission)
GROUP BY country, year
ORDER BY total_emission DESC;
/*
-- Observation:
-- China has the highest total emission in 2023,followed by the United States and India.
-- The results are sorted in descending order of total emission.
*/

-- Q2.What are the top 5 countries by GDP in the most recent year?

SELECT Country,year,Value AS GDP FROM gdp WHERE year = (SELECT MAX(year) FROM gdp) ORDER BY Value DESC LIMIT 5;
/*
--  Observation:
-- The top 5 countries by GDP in the most recent year (2024) are China, United States, India, Japan, and Germany.
-- China has the highest GDP among the countries shown.
*/

-- Q3.Compare energy production and consumption by country and year. 
SELECT
    p.country,
    p.year,
    p.energy,
    p.production,
    c.consumption
FROM production p
JOIN consumption c
    ON p.country = c.country
    AND p.energy = c.energy
    AND p.year = c.year
ORDER BY p.country, p.year, p.energy;

/*
-- Observation:
-- Energy production and consumption were compared for each country,year, and energy type.
-- The results show the production and consumption values side by side, making it possible to identify whether a country produced more energy
     than it consumed or consumed more than it produced.
*/

-- Q4.Which energy types contribute most to emissions across all countries?
SELECT
    energy_type,
    SUM(emission) AS total_emission
FROM emission
GROUP BY energy_type
ORDER BY total_emission DESC;

/*
--  Observation:
-- CO2 emissions contribute the most to total emissions, with a total of 142,723.
-- Coal and coke rank second with 63,945, followed by
-- petroleum and other liquids with 47,297 and 
-- consumed natural gas with 31,469.
-- Therefore, CO2 emissions have the largest contribution among the energy types in the dataset.
*/

-- =====================================================
-- TREND ANALYSIS OVER TIME
-- =====================================================

-- Q5. How have global emissions changed year over year?

SELECT
    year,
    SUM(emission) AS global_emission
FROM emission
GROUP BY year
ORDER BY year;

/*
-- Observation:
-- Global emissions increased continuously from 67,052 in 2020 to 74,161 in 2023.
-- Emissions increased by 3,924 from 2020 to 2021, by 1,469 from 2021 to 2022, and by 1,716 from 2022 to 2023.
-- Therefore, the dataset shows a consistent year-over-year increase in global emissions during 2020–2023.
*/

-- Q6. How has GDP changed over time for each country?
SELECT
    Country,
    year,
    Value AS GDP
FROM gdp
ORDER BY Country, year;
/* 
-- Observation:
-- GDP values were analyzed for each country across the available years.
-- The results show the GDP trend from 2020 to 2024 for each country.
-- This allows comparison of whether GDP increased or decreased over time.
*/

-- Q7. How has population growth affected total emissions in each country?

SELECT
    p.countries AS country,
    p.year,
    p.Value AS population,
    SUM(e.emission) AS total_emission
FROM population p
JOIN emission e
    ON p.countries = e.country
    AND p.year = e.year
GROUP BY
    p.countries,
    p.year,
    p.Value
ORDER BY
    p.countries,
    p.year;
    
    /*
-- Observation:
-- Population and total emissions were compared for each country and year.
-- The results show that population growth does not always lead to an increase in total emissions.
-- For example, Afghanistan's population increased from 39,068.98 in 2020
    to 41,454.76 in 2023, while total emissions decreased from 18 to 16.
-- Therefore, population growth alone does not fully explain changes in emissions.
*/

-- Q8. Has energy consumption increased or decreased over the years for major economies?

SELECT
    country,
    year,
    SUM(consumption) AS total_consumption
FROM consumption
WHERE country IN (
    'China',
    'United States',
    'India',
    'Japan',
    'Germany'
)
GROUP BY
    country,
    year
ORDER BY
    country,
    year;
    
    /*
-- Observation:
-- Energy consumption was analyzed for five major economies (China, United States, India, Japan, and Germany) from 2020 to 2023.
-- China shows a continuous increase in total energy consumption, rising from 156 in 2020 to 177 in 2023.
-- The comparison allows us to identify increasing or decreasing consumption patterns among the major economies.
*/

-- Q9. What is the average yearly change in emissions per capita for each country?

WITH yearly_emission AS (
    SELECT
        country,
        year,
        AVG(per_capita_emission) AS per_capita_emission
    FROM emission
    GROUP BY country, year
),
yearly_change AS (
    SELECT
        country,
        year,
        per_capita_emission,
        per_capita_emission
        - LAG(per_capita_emission) OVER (
            PARTITION BY country
            ORDER BY year
        ) AS yearly_change
    FROM yearly_emission
)
SELECT
    country,
    ROUND(AVG(yearly_change), 6) AS avg_yearly_change
FROM yearly_change
WHERE yearly_change IS NOT NULL
GROUP BY country
ORDER BY avg_yearly_change DESC;

/*
-- Observation:
-- The average yearly change in per-capita emissions was calculated for each country using the available yearly data.
-- The results show an average change of 0 for the countries displayed.
-- This indicates that the per_capita_emission values in the imported dataset show no year-to-year variation for these records.
*/

-- Q10. What is the emission-to-GDP ratio for each country by year?

SELECT
    e.country,
    e.year,
    SUM(e.emission) AS total_emission,
    g.Value AS GDP,
    ROUND(
        SUM(e.emission) / NULLIF(g.Value, 0),
        6
    ) AS emission_to_GDP_ratio
FROM emission e
JOIN gdp g
    ON e.country = g.Country
    AND e.year = g.year
GROUP BY
    e.country,
    e.year,
    g.Value
ORDER BY
    e.country,
    e.year;
    
    /*
-- Observation:
-- The emission-to-GDP ratio was calculated for each country and year.
-- A higher ratio indicates higher emissions relative to GDP.
-- Afghanistan's ratio increased in 2021 and then decreased by 2023.
*/

-- Q11. What is the energy consumption per capita for each country?

SELECT
    c.country,
    c.year,
    SUM(c.consumption) AS total_consumption,
    p.Value AS population,
    ROUND(
        SUM(c.consumption) / NULLIF(p.Value, 0),
        6
    ) AS consumption_per_capita
FROM consumption c
JOIN population p
    ON c.country = p.countries
    AND c.year = p.year
GROUP BY
    c.country,
    c.year,
    p.Value
ORDER BY
    c.country,
    c.year;
    
    /*
-- Observation:
-- Consumption per capita was calculated by comparing total consumption with population.
-- Countries with zero consumption have a consumption per capita of zero.
*/

-- Q12. How does energy production per capita vary across countries?

SELECT
    p.country,
    p.year,
    SUM(p.production) AS total_production,
    pop.Value AS population,
    ROUND(SUM(p.production) / pop.Value, 6) AS production_per_capita
FROM production p
JOIN population pop
    ON p.country = pop.countries
    AND p.year = pop.year
GROUP BY
    p.country,
    p.year,
    pop.Value
ORDER BY
    p.country,
    p.year;
    
    /*
-- Observation:
-- Energy production per capita was calculated for each country and year.
-- Countries with zero production have a production per capita of zero.
*/
-- Q13. Which countries have the highest energy consumption relative to GDP?

SELECT
    c.country,
    c.year,
    SUM(c.consumption) AS total_consumption,
    g.Value AS GDP,
    ROUND(SUM(c.consumption) / g.Value, 6) AS consumption_to_GDP_ratio
FROM consumption c
JOIN gdp g
    ON c.country = g.Country
    AND c.year = g.year
WHERE g.Value > 0
GROUP BY
    c.country,
    c.year,
    g.Value
ORDER BY
    consumption_to_GDP_ratio DESC;
    /*
-- Observation:
-- Trinidad and Tobago has the highest consumption-to-GDP ratio in the visible results.
-- A higher ratio indicates greater energy consumption relative to GDP.
*/

-- Q14. What is the correlation between GDP growth and energy production growth?

WITH yearly_data AS (
    SELECT
        p.country,
        p.year,
        SUM(p.production) AS total_production,
        g.Value AS GDP
    FROM production p
    JOIN gdp g
        ON p.country = g.Country
        AND p.year = g.year
    GROUP BY
        p.country,
        p.year,
        g.Value
),
growth_data AS (
    SELECT
        country,
        year,
        total_production,
        GDP,
        LAG(total_production) OVER (
            PARTITION BY country
            ORDER BY year
        ) AS previous_production,
        LAG(GDP) OVER (
            PARTITION BY country
            ORDER BY year
        ) AS previous_GDP
    FROM yearly_data
)
SELECT
    ROUND(
        (
            SUM(
                (GDP - previous_GDP) *
                (total_production - previous_production)
            )
            /
            SQRT(
                SUM(POWER(GDP - previous_GDP, 2)) *
                SUM(POWER(total_production - previous_production, 2))
            )
        ),
        4
    ) AS GDP_production_correlation
FROM growth_data
WHERE previous_GDP IS NOT NULL
  AND previous_production IS NOT NULL;
  
  /*
-- Observation:
-- GDP and energy production show a moderate positive correlation of 0.6228.
-- This suggests that higher GDP growth is generally associated with higher energy production growth.
*/

-- Q15. Top 10 countries by population and their emissions

SELECT
    p.countries AS country,
    p.year,
    p.Value AS population,
    SUM(e.emission) AS total_emission
FROM population p
JOIN emission e
    ON p.countries = e.country
    AND p.year = e.year
GROUP BY
    p.countries,
    p.year,
    p.Value
ORDER BY
    p.Value DESC
LIMIT 10;
/*
-- Observation:
-- India and China have the largest populations among the top 10 countries.
-- China has much higher total emissions than India in the given years.
*/

-- Q16. Which countries have improved (reduced) their per-capita emissions the most?

SELECT
    country,
    MAX(CASE WHEN year = 2020 THEN per_capita_emission END) AS emission_2020,
    MAX(CASE WHEN year = 2023 THEN per_capita_emission END) AS emission_2023,
    ROUND(
        MAX(CASE WHEN year = 2020 THEN per_capita_emission END)
        -
        MAX(CASE WHEN year = 2023 THEN per_capita_emission END),
        6
    ) AS reduction
FROM emission
GROUP BY country
HAVING emission_2020 IS NOT NULL
   AND emission_2023 IS NOT NULL
ORDER BY reduction DESC
LIMIT 10;
/*
-- Observation:
-- The visible countries show no reduction in per-capita emissions.
-- Their 2020 and 2023 values are the same, resulting in a reduction of 0.
*/

-- Q17. What is the global share (%) of emissions by country?

SELECT
    country,
    SUM(emission) AS total_emission,
    ROUND(
        SUM(emission) * 100.0 / (SELECT SUM(emission) FROM emission),
        2
    ) AS global_emission_share
FROM emission
GROUP BY country
ORDER BY global_emission_share DESC
LIMIT 10;

/*
-- Observation:
-- China has the highest global emission share at 32.35%.
-- The United States follows with 13.47%, while India contributes 7.09%.
-- China accounts for nearly one-third of the total emissions in the dataset.
*/


-- Q18. Global average GDP, emission, and population by year

SELECT
    g.year,
    ROUND(AVG(g.Value), 2) AS average_GDP,
    ROUND(AVG(e.total_emission), 2) AS average_emission,
    ROUND(AVG(p.Value), 2) AS average_population
FROM gdp g
JOIN (
    SELECT country, year, SUM(emission) AS total_emission
    FROM emission
    GROUP BY country, year
) e
    ON g.Country = e.country
    AND g.year = e.year
JOIN population p
    ON g.Country = p.countries
    AND g.year = p.year
GROUP BY g.year
ORDER BY g.year;

/*
-- Observation:
-- Average GDP, emissions, and population increased steadily from 2020 to 2023.
-- Average GDP increased from 624.40 to 711.82.
-- Average emissions increased from 339.02 to 370.55.
-- Average population also increased during this period.
*/