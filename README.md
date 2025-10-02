# Netflix-Data-Analysis-EDA-SQL-Power-BI
Performed comprehensive analysis on `Netflix shows and movies` dataset using multiple tools. Conducted exploratory data analysis (EDA) in Python, queried and managed data with MySQL, processed and analyzed data in Excel, and created interactive dashboards in Power BI to uncover trends in release patterns, genres, ratings, and cast/director insights.

# Netflix EDA & Data Cleaning 

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


# MySQL Data Analysis 

## Project Overview

This project focuses on analyzing the Netflix dataset to gain actionable insights related to content strategy, audience targeting, and operational trends. It leverages SQL for data exploration, aggregation, and trend analysis.

The dataset contains information about movies and TV shows on Netflix, including release dates, genres, ratings, directors, cast, countries, and duration.


## 1) Analysis Questions & Insights

### Content Strategy & Catalog Insights

Q.1) Dominant Content Type: Movies vs TV Shows → Identify which type dominates the catalog.

Q.2) Top 10 Genres: The most common genres on Netflix based on listed_in.

Q.3) Top Content-Producing Countries: Countries contributing the most shows.

Q.4) Top 5 Directors: Directors with the most titles on Netflix.

Q.5) Top Actors/Actresses: Most frequently appearing cast members.

### Trends & Growth Analysis

Q.6) Shows Released Over Years: Trend of content production over time.

Q.7) Month-wise Releases: Identify months with the highest number of releases.

Q.8) Recent Additions vs Older Titles: Are more shows added recently?

Q.9) Ratings Over Time: Trends of content ratings (TV-MA, PG, R) across years.

Q.10) Trending Genres in Last 5 Years: Comparison of genre popularity in recent vs earlier years.

### Audience Targeting & Market Expansion

Q.11) Movies vs TV Shows by Country: Which countries dominate which type.

Q.12) Popularity of Content Type per Country: Identify content type preferences.

Q.13) Family-Friendly Content Trends: Are G/PG content increasing or decreasing?

Q.14) Genres for Kids vs Adults: Most common genres based on audience type.

Q.15) Countries with Most Diverse Genres: Measure of genre diversity by country.

### Operational Insights

Q.16) Weekdays vs Weekends: How shows are added across weekdays/weekends.

Q.17) Average Movie Duration: Average duration of movies in minutes.

Q.18) Longest TV Shows: TV shows with the most seasons.

Q.19) Seasonal Genre Trends: Genres more likely to be added in specific months.

Q.20) Recent Releases by Country: Countries contributing most to recent releases (last 3 years).


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
  
