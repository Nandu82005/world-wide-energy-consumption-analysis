# World Wide Energy Consumption Analysis

## Project Overview

This project analyzes worldwide energy consumption, production, emissions, GDP, and population data using SQL.

The analysis focuses on understanding global energy trends, comparing countries, and examining relationships between energy usage, economic activity, population, and emissions.

## Objectives

- Analyze total emissions by country
- Identify countries with the highest GDP
- Compare energy production and consumption
- Analyze global emission trends over time
- Study the relationship between population and emissions
- Compare energy consumption across major economies
- Calculate per-capita energy consumption and production
- Analyze energy consumption and emissions relative to GDP
- Measure the relationship between GDP changes and energy production changes
- Analyze global emission shares by country

## Database Structure

The project uses six tables:

| Table | Description |
|---|---|
| `country` | Country reference table |
| `emission` | Energy-related emissions data |
| `population` | Country population data |
| `production` | Energy production data |
| `gdp` | GDP data |
| `consumption` | Energy consumption data |

The tables are connected using foreign-key relationships through country names.

## SQL Analysis

The project contains 18 analytical questions covering:

### General & Comparative Analysis
- Total emissions by country for the latest available year
- Top countries by GDP
- Energy production vs. consumption
- Emissions by energy type

### Trend Analysis
- Global emissions over time
- GDP trends by country
- Population and emissions comparison
- Energy consumption trends for major economies

### Advanced Analysis
- Average yearly change in per-capita emissions
- Emission-to-GDP ratio
- Energy consumption per capita
- Energy production per capita
- Consumption-to-GDP ratio
- GDP and energy production correlation
- Population and emissions comparison
- Global emission share by country
- Average GDP, emissions, and population by year

## Key Findings

- China recorded the highest total emissions in the latest emission year available in the dataset.
- China, the United States, and India were among the leading countries in total emissions.
- Global emissions increased from 2020 to 2023 in the dataset.
- CO2 was the largest contributing energy type to total emissions.
- China showed increasing energy consumption across the analyzed years.
- Population growth did not always correspond to higher emissions.
- China accounted for the largest share of total emissions in the dataset.
- GDP changes and energy production changes showed a moderate positive correlation of approximately 0.6228.

## SQL Concepts Used

- Database and table creation
- Primary keys
- Foreign keys
- Aggregate functions
- `GROUP BY`
- `ORDER BY`
- `WHERE`
- `HAVING`
- `JOIN`
- Subqueries
- Common Table Expressions (CTEs)
- `LAG()` window function
- `CASE` statements
- `LIMIT`
- `NULLIF`
- Mathematical calculations
- Correlation calculation
- Per-capita analysis
- Ratio analysis

## Tools

- MySQL
- SQL
- GitHub

## Project File

`World_Wide_Energy_Consumption.sql`

The SQL file contains the database creation, table definitions, relationships, analytical queries, and observations.

## How to Run

1. Open MySQL.
2. Open `World_Wide_Energy_Consumption.sql`.
3. Execute the script to create the `ENERGYDB2` database and tables.
4. Load the required data into the tables.
5. Execute the analytical queries to reproduce the analysis.

## Conclusion

This project demonstrates the use of SQL to perform exploratory and comparative analysis on global energy, economic, population, and emissions data.

The analysis combines multiple datasets using relational joins and applies aggregation, trend analysis, ratios, per-capita calculations, CTEs, and window functions to derive insights.
