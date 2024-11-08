create database netflix;
use netflix;
CREATE TABLE netflix_data
(
	show_id	VARCHAR(10) primary key not null,
	type    VARCHAR(10) not null,
	title	VARCHAR(250) not null,
	director VARCHAR(550) not null,
	casts	VARCHAR(1050) not null,
	country	VARCHAR(550) not null,
	release_year	INT not null,
	rating	VARCHAR(15) not null,
	duration	VARCHAR(15) not null,
	listed_in	VARCHAR(250) not null,
	description VARCHAR(550) not null
);

select * from netflix_data;
describe netflix_data;


-- 1. Count the number of Movies vs TV Shows

select type,count(show_id)as type_count
from netflix_data
group by type;

-- 2. Find the most common rating for movies and TV shows

select aa.*
from
(select a.*,
row_number()over(partition by a.type order by a.rating_count desc)as rating_count_rank
from
(select type,rating,count(rating)as rating_count
from netflix_data
group by type,rating)as a)as aa
where rating_count_rank in (1,2)
;

-- 3. List all movies released in a specific year (e.g., 2020)

select type,title from netflix_data
where release_year=2020 and type="movie";

-- 4. Find the top 5 countries with the most content on Netflix
select * from netflix_data;

select country,count(show_id)as show_count
from netflix_data
group by country
order by count(show_id) desc
limit 5;

-- 5. Identify the longest movie

select * from netflix_data;
 select show_id,title,duration
 from netflix_data
 order by duration desc
 limit 5;
 
-- 6. Find all the movies/TV shows by director 'Reginald Hudlin'!

select * from netflix_data
where director like "Reginald Hudlin" ;

-- 7. Count the number of content items in each genre

select listed_in,count(show_id)as count_show
from netflix_data
group by listed_in
order by count(show_id) desc;

-- 8. Find each year and the numbers of content release in India on netflix. 
--   return top 5 year with highest  content release!

select release_year,count(show_id)as show_count from netflix_data
where country like "india"
group by release_year
order by count(show_id) desc 
limit 5;



-- 9. List all movies that are documentaries

select show_id,title
from netflix_data
where listed_in like 'documentaries';

-- 10. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix_data
where casts like "%salman khan%";


-- 11.
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

select a.content,count(a.show_id)as show_count
from
(select show_id,title,
case
when description like "%kill%" or "%violence%" then "Bad"
else "Good"
end as content
from netflix_data)as a
group by a.content;