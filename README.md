# Netflix Data Analysis — EDA, SQL & Power BI

**Performed comprehensive analysis on the `Netflix shows and movies` dataset using Python (EDA), MySQL (data wrangling & queries), Excel (ad hoc checks), and Power BI (interactive dashboards).**
The analysis uncovers trends in release patterns, genres, ratings, and cast/director insights.

---

# *Netflix EDA & Data Cleaning* 

##  Project Overview

This project focuses on **Exploratory Data Analysis (EDA)** and **Data Cleaning** of the Netflix dataset.
The goal is to explore trends, clean messy data, and prepare it for further analysis or machine learning applications.

##  Objectives

* Understand the structure of the Netflix dataset
* Perform data cleaning (handle missing values, duplicates, and inconsistencies)
* Conduct exploratory data analysis (EDA) to identify trends and patterns
* Visualize insights with Python libraries

##  Dataset Description

The dataset contains information about movies and TV shows available on Netflix, including:

* **Title**
* **Director**
* **Cast**
* **Country**
* **Date Added**
* **Release Year**
* **Rating**
* **Duration**
* **Listed in (Genre)**
* **Description**

##  Steps Performed

1. **Data Cleaning**

   * Handled missing values
   * Removed duplicates
   * Standardized column names and formats

2. **Exploratory Data Analysis (EDA)**

   * Distribution of content by type (Movies vs TV Shows)
   * Most common genres
   * Trend of content added over the years
   * Country-wise contribution to Netflix library
   * Analysis of ratings and duration

3. **Visualizations**

   * Count plots, bar charts, pie charts
   * Trend analysis with line plots
   * Word cloud for genres/descriptions

##  Key Insights

* Movies dominate the Netflix library compared to TV Shows
* Certain genres (like Drama, International Movies) are highly represented
* The number of new titles peaked in recent years
* USA and India contribute a large share of Netflix content

##  Conclusion

This project provides a clear understanding of Netflix's content library, highlights data cleaning techniques, and showcases insights through EDA.
It serves as a foundation for further projects like recommendation systems or predictive modeling.


# *MySQL Data Analysis* 

# SQL Queries for Netflix Analysis (MySQL 8.0+)

**Assumptions**

* Table name: `netflix`
* Relevant columns: `show_id`, `type`, `title`, `director`, `cast`, `country`, `date_added`, `release_year`, `rating`, `duration`, `listed_in`, `description`
* `date_added` may be a string like 'September 9, 2019'. Use `STR_TO_DATE(date_added, '%B %d, %Y')` if necessary.

---

## Helpful utilities (convert comma-list to rows using JSON_TABLE)

```sql
-- Example: split `listed_in` into rows (works in MySQL 8)
SELECT jt.genre, COUNT(*) AS cnt
FROM netflix
JOIN JSON_TABLE(
  CONCAT('["', REPLACE(COALESCE(listed_in,''), ', ', '","'), '"]'),
  '$[*]' COLUMNS (genre VARCHAR(255) PATH '$')
) AS jt
GROUP BY jt.genre
ORDER BY cnt DESC;
```

---

### Q1) Dominant Content Type: Movies vs TV Shows

```sql
SELECT type, COUNT(*) AS Total_Count 
FROM Netflix_data
GROUP BY type
ORDER BY Total_Count DESC 
LIMIT 1 ;
```

### Q2) Top 10 Genres (from `listed_in`)

```sql
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
```

### Q3) Top Content-Producing Countries

```sql
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
```

### Q4) Top 5 Directors

```sql
SELECT director, COUNT(*) AS total_titles
FROM Netflix_data
WHERE director IS NOT NULL AND director <> ''
GROUP BY director
ORDER BY total_titles DESC
LIMIT 5;
```

### Q5) Top Actors/Actresses (most frequent cast members)

```sql
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
```

### Q6) Shows Released Over Years

```sql
SELECT release_year, COUNT(*) AS Total_Titles 
FROM Netflix_data
GROUP BY release_year 
ORDER BY Total_Titles ASC ; 
```

### Q7) Month-wise Releases (by `date_added`)

```sql
SELECT month_name, COUNT(*) AS Total_releases
FROM Netflix_data
GROUP BY month_name
ORDER BY Total_releases DESC 
LIMIT 1 ;
```

### Q8) Recent Additions vs Older Titles (counts by decade or year)

```sql
-- Counts by year added (use date_added year if available)
SELECT YEAR(date_added) AS added_year, COUNT(*) AS total_titles
FROM Netflix_data
WHERE date_added IS NOT NULL
GROUP BY YEAR(date_added)
ORDER BY added_year;
```

### Q9) Ratings Over Time

```sql
SELECT release_year, rating, COUNT(*) AS total_titles
FROM Netflix_data
WHERE release_year IS NOT NULL AND rating IS NOT NULL AND rating <> ''
GROUP BY release_year, rating
ORDER BY release_year, total_titles DESC;
```

### Q10) Trending Genres in Last 5 Years vs Earlier

```sql
-- Last 5 years
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
```

### Q11) Movies vs TV Shows by Country

```sql
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
```

### Q12) Popularity of Content Type per Country (percentage)

```sql
-- Example for a single country (replace 'India' with variable)
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
```

### Q13) Family-Friendly Content Trends (G / PG)

```sql
SELECT 
    release_year,
    SUM(CASE WHEN rating IN ('G', 'PG', 'TV-Y', 'TV-G', 'TV-Y7') THEN 1 ELSE 0 END) AS family_friendly_titles,
    COUNT(*) AS total_titles
FROM Netflix_data
WHERE release_year IS NOT NULL
GROUP BY release_year
ORDER BY release_year;
```

### Q14) Genres for Kids vs Adults (sample mapping)

```sql
-- Kids genres (example list)
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
```

### Q15) Countries with Most Diverse Genres (genre count per country)

```sql
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
```

### Q16) Weekdays vs Weekends (date_added)

```sql
SELECT 
    CASE 
        WHEN day_of_week IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS total_titles
FROM Netflix_data
WHERE day_of_week IS NOT NULL
GROUP BY day_type;
```

### Q17) Average Movie Duration (minutes)

```sql
SELECT 
    AVG(CAST(REPLACE(duration, ' min', '') AS UNSIGNED)) AS avg_movie_duration_minutes
FROM Netflix_data
WHERE type = 'Movie' AND duration LIKE '%min%';
```

### Q18) Longest TV Shows (most seasons)

```sql
SELECT 
    title,
    CAST(REPLACE(duration, ' Seasons', '') AS UNSIGNED) AS num_seasons
FROM Netflix_data
WHERE type = 'TV Show' AND duration LIKE '%Season%'
ORDER BY num_seasons DESC
LIMIT 10;
```

### Q19) Seasonal Genre Trends (genres added by month)

```sql
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
```

### Q20) Recent Releases by Country (last 3 years)

```sql
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

```

---



## Tools & Technologies Used

### SQL / MySQL → For data cleaning, aggregation, and querying

### CSV Dataset → Netflix show metadata

### Data Analysis Techniques:

* String manipulation to split multiple genres, countries, or cast

* Aggregations for counts, averages, and trends

* Grouping by time, genre, rating, and country


## Key Takeaways

* Movies dominate Netflix content, but TV shows have strong regional popularity.

* Dramas, Comedies, and International Movies are top genres.

* US, India, and UK contribute most of the content.

* Family-friendly content is gradually increasing, catering to kids and families.

* Certain genres show seasonal trends, e.g., kids’ content during summer.

* Countries like the US show the most genre diversity, while others focus on specific content types.
  
