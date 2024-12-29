SELECT *
FROM updated_pollution_dataset;

SELECT DISTINCT `Air Quality`
FROM updated_pollution_dataset;

SELECT DISTINCT population_density
FROM updated_pollution_dataset;

SELECT DISTINCT MAX(`Temperature`)
FROM updated_pollution_dataset;

SELECT *
FROM updated_pollution_dataset
WHERE `Temperature` = 58.6;

SELECT *
FROM updated_pollution_dataset
WHERE `Air Quality` LIKE 'Hazardous';

SELECT *
FROM updated_pollution_dataset
WHERE `Air Quality` LIKE 'Good';

-- General Trends 

-- Trends in Air Quality Components
SELECT 
    `Air Quality`,
    COUNT(*) AS count,
    ROUND(AVG(Temperature), 2) AS avg_temperature,
    ROUND(AVG(Humidity), 2) AS avg_humidity
FROM updated_pollution_dataset
GROUP BY `Air Quality`
ORDER BY count DESC;

-- Population Density and Proximity to Industrial Areas
SELECT `Air Quality`,
    ROUND(AVG(Population_Density), 2) AS avg_population_density,
    ROUND(AVG(Proximity_to_Industrial_Areas), 2) AS avg_proximity_industrial
FROM updated_pollution_dataset
GROUP BY `Air Quality`;

SELECT 
    `Air Quality`,
    ROUND(AVG(`PM2.5`), 2) AS avg_pm25,
    ROUND(AVG(`PM10`), 2) AS avg_pm10,
    ROUND(AVG(`NO2`), 2) AS avg_no2,
    ROUND(AVG(`SO2`), 2) AS avg_so2,
    ROUND(AVG(`CO`), 2) AS avg_co
FROM updated_pollution_dataset
GROUP BY `Air Quality`
ORDER BY avg_pm25 DESC;

SELECT
    *,
    RANK() OVER (ORDER BY `PM2.5` DESC) AS pm25_rank,
    RANK() OVER (ORDER BY PM10 DESC) AS pm10_rank,
    RANK() OVER (ORDER BY NO2 DESC) AS no2_rank,
    RANK() OVER (ORDER BY SO2 DESC) AS so2_rank
FROM updated_pollution_dataset
LIMIT 10;

-- Identifying Regions/Conditions That Frequently Trigger "Hazardous" Air Quality
SELECT
    ROUND(AVG(Temperature), 2) AS avg_temperature,
    ROUND(AVG(Humidity), 2) AS avg_humidity,
    ROUND(AVG(`PM2.5`), 2) AS avg_pm25,
    ROUND(AVG(PM10), 2) AS avg_pm10
FROM updated_pollution_dataset
WHERE `Air Quality` = 'Hazardous';


-- Distribution of Air Quality by Population Density Buckets
SELECT
    CASE
        WHEN Population_Density < 500 THEN 'Low Population Density'
        WHEN Population_Density BETWEEN 500 AND 1000 THEN 'Medium Population Density'
        ELSE 'High Population Density'
    END AS population_density_bucket,
    COUNT(*) AS record_count,
    ROUND(AVG(`PM2.5`), 3) AS avg_pm25
FROM updated_pollution_dataset
GROUP BY population_density_bucket
ORDER BY avg_pm25 DESC;


-- Inserting above to table
ALTER TABLE updated_pollution_dataset
ADD population_density_bucket VARCHAR(50);

-- Update new column based on population density
UPDATE updated_pollution_dataset
SET population_density_bucket = CASE
        WHEN Population_Density < 500 THEN 'Low Population Density'
        WHEN Population_Density BETWEEN 500 AND 1000 THEN 'Medium Population Density'
        ELSE 'High Population Density'
END;

SELECT population_density_bucket, COUNT(*) AS record_count,
ROUND(AVG(`PM2.5`), 3) AS avg_pm25
FROM updated_pollution_dataset
GROUP BY population_density_bucket
ORDER BY avg_pm25 DESC;

-- Determining correlation between air quality and proximity to industrial areas

SELECT Proximity_to_Industrial_Areas, ROUND(AVG(`PM2.5`), 4) AS avg_pm25
FROM updated_pollution_dataset
GROUP BY Proximity_to_Industrial_Areas
ORDER BY Proximity_to_Industrial_Areas;

SELECT
    CASE
        WHEN Proximity_to_Industrial_Areas < 5 THEN 'Near'
        WHEN Proximity_to_Industrial_Areas BETWEEN 5 AND 20 THEN 'Medium'
        ELSE 'Far'
    END AS proximity_category,
    ROUND(AVG(`PM2.5`), 3) AS avg_pm25
FROM updated_pollution_dataset
GROUP BY Proximity_to_Industrial_Areas;

SELECT Proximity_to_Industrial_Areas, `PM2.5`
FROM updated_pollution_dataset
WHERE Proximity_to_Industrial_Areas IS NOT NULL AND `PM2.5` IS NOT NULL;



