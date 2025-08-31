
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix;
--1. Count the number of Movies vs TV Shows
select  type,count(type)as movie_type  from netflix
group by type

--extra total null values in the below 4 columns

SELECT
  SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS total_null_directors,
  SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS total_null_countries,
  SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS total_null_titles,
  SUM(CASE WHEN casts IS NULL THEN 1 ELSE 0 END) AS total_null_casts,
  SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS total_null_rartevalues
  
FROM netflix

--extra2 Find the most common rating for movies and TV shows
SELECT rating ,
count(*)
FROM netflix
where rating is not null
group by rating
order by 2 desc
SELECT * FROM netflix;
--2. Find the most common rating for movies and TV shows
--3. List all movies released in a specific year (e.g., 2020)
select title, release_year
from netflix 
where type in ('Movie')
    and release_year=2021
--4. Find the top 5 countries with the most content on Netflix
   /*select country ,count(show_id)as content
   from netflix
   group by country*/
 select
count(show_id)as content,
trim(unnest( string_TO_array (country,',' )))as new_country
from netflix
group by 2
order  by 1 desc
limit 5

--5. Identify the longest movie
select *
from netflix
where upper(type)='MOVIE'
and
duration=(select max(duration) from netflix)
--6. Find content added in the last 5 years
seLECT * FROM netflix;

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select*from netflix
where director ilike'%Rajiv Chilaka%'
--8. List all TV shows with more than 5 seasons
/*select* 
from  netflix
where type 'Tv Show'
duration> 5 seasons*/

select*,
SPLIT_PART(trim(duration),' ' ,1)as number_of_seasons
from  netflix
where type='TV Show'
and
SPLIT_PART(trim(duration),' ' ,1)::integer>5
--9. Count the number of content items in each genre
/*select show_id,listed_in
from netflix*/
 
 select trim(unnest(string_to_array(listed_in, ',')))as genre,
 count(show_id)
 from netflix
group by 1
--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

--11. List all movies that are documentaries
select* from netflix
where listed_in ilike '%documentaries%'

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from netflix
where type='Movie'
and casts ilike '%Salman khan%'
and
release_year>=Extract(year from current_date-interval '10 years')
--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
15.
/*Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.*/
SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2

