## Create Database Of Netflix 

DROP DATABASE IF EXISTS Netflix_Data_Analysis ;
CREATE DATABASE Netflix_Data_Analysis;

USE Netflix_Data_Analysis;

## Create table schemas for Netflix Data Analysis

DROP TABLE IF EXISTS Netflix_data ;

CREATE TABLE Netflix_data (
show_id	VARCHAR(10) ,
type VARCHAR(10) ,
title VARCHAR(500) ,
director VARCHAR(200) ,
cast VARCHAR(500) ,
country	VARCHAR(100) ,
date_added DATE ,
release_year INT ,
rating	VARCHAR(100) ,
duration VARCHAR(200) ,
listed_in VARCHAR(200) ,
description	VARCHAR(500) ,
day INT ,
month INT ,
month_name	VARCHAR(100) ,
day_of_week VARCHAR(100) 

);

## Load Dataset using Code 

SET GLOBAL LOCAL_INFILE=ON;
LOAD DATA LOCAL INFILE "C:/Users/Lenovo/OneDrive/Documents/Python Programming/Data_Analysis/Netfilx_EDA&DataCleaning.csv"  INTO TABLE Netflix_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

## After Load Dataset check Again 

SELECT * FROM Netflix_data;




------------------------------ Content Strategy & Catalog Insights --------------------------------------------

# Q.1) Which type of content (Movies vs TV Shows) is more dominant on Netflix?

SELECT type, COUNT(*) AS Total_Count 
FROM Netflix_data
GROUP BY type
ORDER BY Total_Count DESC 
LIMIT 1 ;


# Q.2)  What are the top 10 genres (from listed_in) available on Netflix?

SELECT genre, COUNT(*) AS total_titles
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS genre
    FROM Netflix_data
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
    ) numbers 
    ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
) AS genre_split
GROUP BY genre
ORDER BY total_titles DESC
LIMIT 10;

# Q.3)  Which countries produce the most Netflix content?

SELECT country_name, COUNT(*) AS total_titles
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', numbers.n), ',', -1)) AS country_name
    FROM Netflix_data
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
    ) numbers 
    ON CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) >= numbers.n - 1
    WHERE country IS NOT NULL AND country <> ''
) AS country_split
GROUP BY country_name
ORDER BY total_titles DESC
LIMIT 10;


# Q.4)	Who are the top 5 directors with the most shows on Netflix?

SELECT director, COUNT(*) AS total_titles
FROM Netflix_data
WHERE director IS NOT NULL AND director <> ''
GROUP BY director
ORDER BY total_titles DESC
LIMIT 5;

# Q.5)  Which actors/actresses appear most frequently in Netflix titles?

SELECT actor_name, COUNT(*) AS total_titles
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', numbers.n), ',', -1)) AS actor_name
    FROM Netflix_data
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 
        UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 
        UNION ALL SELECT 10
    ) numbers
    ON CHAR_LENGTH(cast) - CHAR_LENGTH(REPLACE(cast, ',', '')) >= numbers.n - 1
    WHERE cast IS NOT NULL AND cast <> ''
) AS cast_split
GROUP BY actor_name
ORDER BY total_titles DESC
LIMIT 10;

----------------------------------------- Trends & Growth Analysis -------------------------------------------

Q.6)  How has the number of shows released changed over the years (release_year)?

SELECT release_year, COUNT(*) AS Total_Titles 
FROM Netflix_data
GROUP BY release_year 
ORDER BY Total_Titles ASC ; 

# Q.7)  Which month of the year has the highest number of releases (month_name)?

SELECT month_name, COUNT(*) AS Total_releases
FROM Netflix_data
GROUP BY month_name
ORDER BY Total_releases DESC 
LIMIT 1 ;

# Q.8) Are more shows being added recently compared to older years (date_added)?

SELECT YEAR(date_added) AS added_year, COUNT(*) AS total_titles
FROM Netflix_data
WHERE date_added IS NOT NULL
GROUP BY YEAR(date_added)
ORDER BY added_year;

# Q.9) What is the trend of ratings (e.g., TV-MA, PG, R) over time?

SELECT release_year, rating, COUNT(*) AS total_titles
FROM Netflix_data
WHERE release_year IS NOT NULL AND rating IS NOT NULL AND rating <> ''
GROUP BY release_year, rating
ORDER BY release_year, total_titles DESC;

# Q.10)  Which genres are trending in the last 5 years compared to earlier years?

SELECT 
    genre_name,
    SUM(CASE WHEN release_year >= YEAR(CURDATE()) - 5 THEN 1 ELSE 0 END) AS last_5_years,
    SUM(CASE WHEN release_year < YEAR(CURDATE()) - 5 THEN 1 ELSE 0 END) AS earlier_years
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS genre_name,
           release_year
    FROM Netflix_data
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
    ) numbers
    ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
    WHERE listed_in IS NOT NULL AND listed_in <> ''
) AS genre_split
GROUP BY genre_name
ORDER BY last_5_years DESC;

----------------------------------  Audience Targeting & Market Expansion -----------------------------------

# Q.11) Which countries dominate Netflix content in terms of movies vs TV shows?

SELECT 
    country_name,
    type,
    COUNT(*) AS total_titles
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', numbers.n), ',', -1)) AS country_name,
        type
    FROM Netflix_data
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
    ) numbers
    ON CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) >= numbers.n - 1
    WHERE country IS NOT NULL AND country <> ''
) AS country_split
GROUP BY country_name, type
ORDER BY country_name, total_titles DESC;

# Q.12) What type of shows (Movie/TV) are more popular in different countries?

SELECT 
    country_name,
    type,
    COUNT(*) AS total_titles
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', numbers.n), ',', -1)) AS country_name,
        type
    FROM Netflix_data
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
    ) numbers
    ON CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) >= numbers.n - 1
    WHERE country IS NOT NULL AND country <> ''
) AS country_split
GROUP BY country_name, type
ORDER BY country_name, total_titles DESC;


# Q.13)  Are family-friendly contents (e.g., G, PG) increasing or decreasing?

SELECT 
    release_year,
    SUM(CASE WHEN rating IN ('G', 'PG', 'TV-Y', 'TV-G', 'TV-Y7') THEN 1 ELSE 0 END) AS family_friendly_titles,
    COUNT(*) AS total_titles
FROM Netflix_data
WHERE release_year IS NOT NULL
GROUP BY release_year
ORDER BY release_year;

# Q.14)  Which genres are most common for kids vs adults (based on rating)?

SELECT 
    audience,
    genre_name,
    COUNT(*) AS total_titles
FROM (
    SELECT 
        CASE 
            WHEN rating IN ('G', 'PG', 'TV-Y', 'TV-G', 'TV-Y7') THEN 'Kids/Family'
            WHEN rating IN ('PG-13', 'R', 'TV-MA', 'NC-17', 'TV-14') THEN 'Adult'
            ELSE 'Other'
        END AS audience,
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS genre_name
    FROM Netflix_data
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
    ) numbers
    ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
    WHERE listed_in IS NOT NULL AND listed_in <> '' AND rating IS NOT NULL
) AS genre_split
WHERE audience <> 'Other'
GROUP BY audience, genre_name
ORDER BY audience, total_titles DESC;

# Q.15)  Which countries have the most diverse genres listed?

SELECT 
    country,
    COUNT(DISTINCT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1))) AS unique_genres
FROM Netflix_data
JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
    UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
) numbers
ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
WHERE country IS NOT NULL AND country <> '' AND listed_in IS NOT NULL AND listed_in <> ''
GROUP BY country
ORDER BY unique_genres DESC
LIMIT 10;

-------------------------------- Operational Insights ---------------------------------------------

# Q.16) How many shows are added on weekdays vs weekends (day_of_week)?

SELECT 
    CASE 
        WHEN day_of_week IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS total_titles
FROM Netflix_data
WHERE day_of_week IS NOT NULL
GROUP BY day_type;

# Q.17)  What is the average duration of movies on Netflix?

SELECT 
    AVG(CAST(REPLACE(duration, ' min', '') AS UNSIGNED)) AS avg_movie_duration_minutes
FROM Netflix_data
WHERE type = 'Movie' AND duration LIKE '%min%';

# Q.18)  Which TV shows have the longest number of seasons (from duration)?

SELECT 
    title,
    CAST(REPLACE(duration, ' Seasons', '') AS UNSIGNED) AS num_seasons
FROM Netflix_data
WHERE type = 'TV Show' AND duration LIKE '%Season%'
ORDER BY num_seasons DESC
LIMIT 10;


# Q.19) Are certain genres more likely to be added in specific months (seasonal trends)?

SELECT 
    month_name,
    genre_name,
    COUNT(*) AS total_titles
FROM (
    SELECT 
        month_name,
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS genre_name
    FROM Netflix_data
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
    ) numbers
    ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
    WHERE listed_in IS NOT NULL AND listed_in <> '' AND month_name IS NOT NULL
) AS genre_split
GROUP BY month_name, genre_name
ORDER BY month_name, total_titles DESC;


# Q.20) Which countries contribute to most recent releases (say last 3 years)?

SELECT 
    country_name,
    COUNT(*) AS total_titles
FROM (
    SELECT 
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', numbers.n), ',', -1)) AS country_name,
        release_year
    FROM Netflix_data
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 
        UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
    ) numbers
    ON CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) >= numbers.n - 1
    WHERE country IS NOT NULL AND country <> '' 
      AND release_year >= (SELECT MAX(release_year) FROM Netflix_data) - 3
) AS country_split
GROUP BY country_name
ORDER BY total_titles DESC
LIMIT 10;

