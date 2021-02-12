USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- query to find out the number of rows in each table
(SELECT 'director_mapping' AS TableName, COUNT(*) AS row_cnt FROM director_mapping) UNION ALL
(SELECT 'genre' AS TableName, COUNT(*) AS row_cnt FROM genre) UNION ALL
(SELECT 'movie' AS TableName, COUNT(*) AS row_cnt FROM movie) UNION ALL
(SELECT 'names' AS TableName, COUNT(*) AS row_cnt FROM names) UNION ALL
(SELECT 'ratings' AS TableName, COUNT(*) AS row_cnt FROM ratings) UNION ALL
(SELECT 'role_mapping' AS TableName, COUNT(*) AS row_cnt FROM role_mapping);







-- Q2. Which columns in the movie table have null values?
-- Type your code below:

WITH null_count AS
(
(SELECT "id" AS ColumnName, SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS null_cnt FROM movie) UNION ALL
(SELECT "title" AS ColumnName, SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS  null_cnt FROM movie) UNION ALL
(SELECT "year" AS ColumnName, SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS  null_cnt FROM movie) UNION ALL
(SELECT "date_published" AS ColumnName, SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS  null_cnt FROM movie) UNION ALL
(SELECT "duration" AS ColumnName, SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS  null_cnt FROM movie) UNION ALL
(SELECT "country" AS ColumnName, SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS  null_cnt FROM movie) UNION ALL
(SELECT "worlwide_gross_income" AS ColumnName, SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS  null_cnt FROM movie) UNION ALL
(SELECT "languages" AS ColumnName, SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS  null_cnt FROM movie) UNION ALL
(SELECT "production_company" AS ColumnName, SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS  null_cnt FROM movie)
)
SELECT ColumnName
FROM null_count
WHERE null_cnt >0;

-- ANS: The columns that have null values are country, world_gross_income, languages and production_company.





-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Query to check the total number of movies released each year
SELECT Year,
	   COUNT(id) AS number_of_movies
FROM movie
GROUP BY Year;

-- The highest number of movies have been produced in the year of 2017. More movies have been produced in the past year than in the recent years.

-- Query to check the trend monthwise
SELECT MONTH(date_published) AS month_num,
	   COUNT(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;

-- Most number of movies have been produced in the month of March




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT count(id) AS count_movies
FROM movie
WHERE (year = 2019) AND 
	  (country LIKE "%USA%" OR country LIKE "%India%");

-- 1059 number of movies have been produced in USA or INDIA in the year 2019.









/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT genre
FROM genre
GROUP BY genre;

-- The unique list of Genre consists of : Drama, Fantasy, Thriller, Comedy, Horror, Family, Romance, Adventure, Action, 
-- Sci-Fi, Crime, Mystery and Others










/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT g.genre,
	   count(DISTINCT m.id) AS movie_cnt
FROM movie AS m
INNER JOIN genre AS g
ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY movie_cnt DESC
LIMIT 1;
	  
-- "Drama" genre has the highest number of movies.









/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH one_genre AS
(
	SELECT movie_id,
		   count(genre) AS genre_cnt
	FROM genre
	GROUP BY movie_id
	HAVING genre_cnt = 1
) 
SELECT count(*) AS count_movie
FROM one_genre;

-- 3289 number of movies are there which belong to only one genre










/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,
	   ROUND(AVG(m.duration),2) AS avg_duration
FROM movie AS m
INNER JOIN genre AS g
ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY avg_duration DESC;

-- "Action" genre has the highest average duration of movies








/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT g.genre,
	   COUNT(DISTINCT m.id) AS movie_count,
       RANK() OVER(ORDER BY COUNT(DISTINCT m.id) DESC) AS genre_rank
FROM movie AS m
INNER JOIN genre AS g
ON m.id = g.movie_id
GROUP BY g.genre;

-- The rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced is 3.







/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating) AS min_avg_rating,
	   MAX(avg_rating) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes,
	   MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
	   MAX(median_rating) AS max_median_rating
FROM ratings;





    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH rating_rank AS
(
SELECT m.title,
	   r.avg_rating,
       DENSE_RANK() OVER(ORDER BY r.avg_rating DESC) as movie_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
)
SELECT *
FROM rating_rank
WHERE movie_rank <=10;





/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
	   COUNT(DISTINCT movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;

-- Movies with median_rating 7 is the highest in number.







/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH prod_rank_summary AS
(
SELECT m.production_company,
	   COUNT(DISTINCT m.id) AS movie_count,
       DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT m.id) DESC) AS prod_company_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE (m.production_company IS NOT NULL) AND (r.avg_rating > 8)
GROUP BY m.production_company
)
SELECT *
FROM prod_rank_summary
WHERE prod_company_rank = 1;

-- Dream Warrior Pictures and National Theatre Live are the production companies that have produced the most number of hits








-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre,
	   COUNT(DISTINCT m.id) AS movie_count
FROM genre AS g
INNER JOIN movie AS m
ON g.movie_id = m.id
LEFT JOIN ratings AS r
ON m.id = r.movie_id
WHERE ((MONTH(m.date_published) = 3) AND (m.year = 2017) AND (m.country LIKE "%USA%") AND (r.total_votes > 1000))
GROUP BY g.genre
ORDER BY movie_count DESC;






-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT m.title,
	   r.avg_rating,
       g.genre
FROM movie AS m
INNER JOIN genre AS g
ON m.id = g.movie_id
INNER JOIN ratings AS r
ON g.movie_id = r.movie_id
WHERE ((m.title LIKE "The%") AND (r.avg_rating > 8))
ORDER BY r.avg_rating DESC;

-- The movies having the highest average rating belongs to the "Drama" genre

-- Checking for median rating
SELECT m.title,
	   r.median_rating,
       g.genre
FROM movie AS m
INNER JOIN genre AS g
ON m.id = g.movie_id
INNER JOIN ratings AS r
ON g.movie_id = r.movie_id
WHERE ((m.title LIKE "The%") AND (r.median_rating > 8))
ORDER BY r.median_rating DESC;

-- The result of using median rating is same as the one done with average rating




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT COUNT(r.movie_id) AS movie_count
FROM movie AS m
LEFT JOIN ratings AS r
ON m.id = r.movie_id
WHERE ((m.date_published BETWEEN '2018-04-01' AND '2019-04-01') AND (r.median_rating = 8));

-- 361 movies have a median rating 8 between the mentioned dates.






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT SUM(r.total_votes) AS german_votes
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE m.languages LIKE "%German%";

-- The total number of votes for the German movies is 4421525.

SELECT SUM(r.total_votes) AS italian_votes
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE m.languages LIKE "%Italian%";

-- The total number of votes for the Italian movies is 2559540.

-- So German movies get greater votes than Italian movies.



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
	   SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
       SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
       SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

-- The "name" column doen't contain any null values.





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Getting the top three genres having most number of movies with an average rating > 8
SELECT g.genre,
	   COUNT(DISTINCT g.movie_id) AS movie_count,
       r.avg_rating
FROM genre AS g
INNER JOIN ratings AS r
ON g.movie_id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY g.genre
ORDER BY movie_count DESC
LIMIT 3;

-- The top three genres are Drama, Action and Comedy

-- Getting the top three directors from the top three genres
(SELECT n.name AS director_name,
	   COUNT(DISTINCT r.movie_id) AS movie_count
FROM names AS n
INNER JOIN director_mapping AS dm
ON n.id = dm.name_id
INNER JOIN ratings AS r
ON dm.movie_id = r.movie_id
INNER JOIN genre AS g
ON r.movie_id = g.movie_id
WHERE g.genre = 'Drama' AND r.avg_rating >8
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 1)
UNION
(SELECT n.name AS director_name,
	   COUNT(DISTINCT r.movie_id) AS movie_count
FROM names AS n
INNER JOIN director_mapping AS dm
ON n.id = dm.name_id
INNER JOIN ratings AS r
ON dm.movie_id = r.movie_id
INNER JOIN genre AS g
ON r.movie_id = g.movie_id
WHERE g.genre = 'Action' AND r.avg_rating >8
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 1)
UNION
(SELECT n.name AS director_name,
	   COUNT(DISTINCT r.movie_id) AS movie_count
FROM names AS n
INNER JOIN director_mapping AS dm
ON n.id = dm.name_id
INNER JOIN ratings AS r
ON dm.movie_id = r.movie_id
INNER JOIN genre AS g
ON r.movie_id = g.movie_id
WHERE g.genre = 'Comedy' AND r.avg_rating >8
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 1);

-- James Mangold, Anthony Russo and Aaron K. Carter are the top 3 directors





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT n.name AS actor_name,
	   COUNT(r.movie_id) AS movie_count
FROM names AS n
INNER JOIN role_mapping AS rm
ON n.id = rm.name_id
INNER JOIN ratings As r
ON rm.movie_id = r.movie_id
WHERE r.median_rating >=8
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

-- The top two actors are Mammootty and Mohanlal.





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_comp_summary AS
(
SELECT m.production_company,
	   SUM(r.total_votes) AS vote_count,
       DENSE_RANK() OVER(ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
GROUP BY m.production_company
)
SELECT *
FROM prod_comp_summary
WHERE prod_comp_rank <=3;

-- Marvel Studios, Twentieth Century Fox and Warner Bros. are the top three production company








/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actor_name,
	   SUM(r.total_votes) AS total_votes,
       COUNT(r.movie_id) AS movie_count,
       (SUM(r.total_votes*r.avg_rating)/SUM(r.total_votes)) AS actor_avg_rating,
       DENSE_RANK() OVER(ORDER BY (SUM(r.total_votes*r.avg_rating)/SUM(r.total_votes)) DESC, r.total_votes DESC) AS actor_rank
FROM names AS n
INNER JOIN role_mapping AS rm
ON n.id = rm.name_id
INNER JOIN movie AS m
ON rm.movie_id = m.id
INNER JOIN ratings As r
ON m.id = r.movie_id
WHERE (rm.category = 'actor') AND (m.country LIKE "%India%")
GROUP BY actor_name
HAVING movie_count >= 5;

-- Vijay Setupathi is the top actor








-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actress_name,
	   SUM(r.total_votes) AS total_votes,
       COUNT(r.movie_id) AS movie_count,
       ROUND(SUM(r.total_votes*r.avg_rating)/SUM(r.total_votes),2) AS actress_avg_rating,
       DENSE_RANK() OVER(ORDER BY (SUM(r.total_votes*r.avg_rating)/SUM(r.total_votes)) DESC, r.total_votes DESC) AS actress_rank
FROM names AS n
INNER JOIN role_mapping AS rm
ON n.id = rm.name_id
INNER JOIN movie AS m
ON rm.movie_id = m.id
INNER JOIN ratings As r
ON m.id = r.movie_id
WHERE (rm.category = 'actress') AND (m.country LIKE "%India%") AND (m.languages LIKE "Hindi")
GROUP BY actress_name
HAVING movie_count >= 3
LIMIT 5;

-- The top 4 actresses are Taapsee Pannu, Divya Dutta, Kriti Kharbanda and Sonakshi Sinha.




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Creating an UDF for the classification
DELIMITER $$

CREATE FUNCTION movie_category(avg_rating float)
RETURNS VARCHAR(30) DETERMINISTIC

BEGIN

DECLARE class VARCHAR(30);
IF avg_rating > 8  THEN
	SET class = 'Superhit Movie';
ELSEIF avg_rating BETWEEN 7 AND 8 THEN 
	SET class = 'Hit Movie';
ELSEIF avg_rating BETWEEN 5 AND 7 THEN
	SET class = 'One-time-watch Movie';
ELSE
	SET class = 'Flop Movie';
END IF;

RETURN class;

END;
$$
DELIMITER ;

SELECT m.title,
	   r.avg_rating,
       movie_category(r.avg_rating) AS movie_category
FROM genre AS g
INNER JOIN movie AS m
ON g.movie_id = m.id
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE g.genre = "Thriller";
	   








/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH genre_duration_summary AS
(
SELECT g.genre AS genre,
	   AVG(m.duration) AS avg_duration
FROM genre AS g
INNER JOIN movie AS m
ON g.movie_id = m.id
GROUP BY g.genre
)
SELECT genre,
	   avg_duration,
	   ROUND(SUM(avg_duration) OVER(ORDER BY genre),2) AS running_total_duration,
       ROUND(AVG(avg_duration) OVER(ORDER BY genre),2) AS moving_avg_duration
FROM genre_duration_summary;
       








-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT * FROM(
WITH top_genre AS(
SELECT g.genre,
	   COUNT(g.movie_id) AS movie_cnt
FROM genre AS g
INNER JOIN movie AS m
ON g.movie_id = m.id
GROUP BY g.genre
ORDER By movie_cnt DESC
LIMIT 3
)
SELECT g.genre,
	   m.year,
       m.title AS movie_name,
       m.worlwide_gross_income AS worldwide_gross_income,
       ROW_NUMBER() OVER(PARTITION BY m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
FROM genre AS g
INNER JOIN movie AS m
ON g.movie_id = m.id
WHERE (m.worlwide_gross_income IS NOT NULL) AND (g.genre IN (SELECT genre FROM top_genre)) AND (m.worlwide_gross_income LIKE "$%")
)s
WHERE s.movie_rank <=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company,
	   COUNT(DISTINCT m.id) AS movie_count,
       DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT m.id) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
WHERE (r.median_rating >= 8) AND (POSITION(',' IN m.languages)>0) AND (m.production_company IS NOT NULL)
GROUP BY m.production_company
LIMIT 2;

-- The top two production companies with highest number of hits are Star Cinema and Twentieth Century Fox







-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.name AS actress_name,
	   SUM(r.total_votes) AS total_votes,
       COUNT(r.movie_id) AS movie_count,
       ROUND(AVG(avg_rating),2) AS actress_avg_rating,
       DENSE_RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actress_rank
FROM names AS n
INNER JOIN role_mapping AS rm
ON n.id = rm.name_id
INNER JOIN genre AS g
ON rm.movie_id = g.movie_id
INNER JOIN ratings As r
ON g.movie_id = r.movie_id
WHERE (rm.category = 'actress') AND (r.avg_rating > 8) AND (g.genre = 'Drama')
GROUP BY actress_name
LIMIT 3;
	   

-- The top three actress with the highest number of superhit movies are : Parvathy Thiruvothu, Susan Brown and Amanda Lawrence



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH inter_movie_days AS
(
SELECT n.id AS director_id, 
	   n.name AS director_name,
       m.id,
	   m.title,
       m.date_published,
       LEAD(date_published,1,'2020-01-01') OVER(PARTITION BY n.name ORDER BY n.name,date_published) AS next_publish_date,
       r.avg_rating,
       r.total_votes,
       m.duration
FROM names AS n
INNER JOIN director_mapping AS dm
ON n.id = dm.name_id
INNER JOIN movie AS m
ON dm.movie_id = m.id
INNER JOIN ratings As r
ON m.id = r.movie_id
)
SELECT director_id, 
	   director_name,
       COUNT(id) AS number_of_movies,
       ROUND(AVG(DATEDIFF(next_publish_date, date_published)),2) as avg_inter_movie_days,
       ROUND(AVG(avg_rating),2) AS avg_rating,
       SUM(total_votes) AS total_votes,
       MIN(avg_rating) AS min_rating,
       MAX(avg_rating) AS max_rating,
       SUM(duration) AS total_duration
FROM inter_movie_days
GROUP BY director_name
ORDER BY number_of_movies DESC
LIMIT 9;

/* From the above it can be seen that most of the top 9 directors have movies with an average rating of around or more,
total votes of more than thousands, with minimum rating not less than 2.5 and maximum rating above 5, duration of each 
movie not extending the duration more than 2.5 hours. Also the average diff between the movie dates is approximately 
above 150 for all the successful top directors.
