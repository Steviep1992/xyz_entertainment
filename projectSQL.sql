use xyz_entertainment;
show tables;

Select * from movies;
Select * from tags;
Select * from ratings limit 10;
Select * from genometags;
Select * from genomescores;
Select * from users order by age;
Select * from links;
ALTER TABLE table_name;
ALTER table `users` CHANGE COLUMN `income_` `income` decimal(65,30);
ALTER table `users` CHANGE COLUMN `userid` `userId` int(11);
describe users;


SET GLOBAL max_allowed_packet = 16777216;
SET GLOBAL max_allowed_packet = 100000000;



Describe links;
Describe movies;
Describe ratings;
Describe tags;
Describe genomescores;
Describe genometags;
Describe users;

SHOW VARIABLES LIKE 'max_allowed_packet';


#2. Prepare a report of popular movie sorted by movie Id Split title and year into separate columns.  
Select * from movies;
SELECT *,SUBSTRING_INDEX(SUBSTRING_INDEX(title,'(',1),')',1) AS only_title, SUBSTRING_INDEX(SUBSTRING_INDEX(title,'(',-1),')',1)  AS years from movies order by movieid;
Select *, substring_index(title, '(',1) as noYear, substring_index(title,'(', -1) as year from movies;
#3. Categorize movies by genres  
Select * from movies order by genres desc;
Select * from movies order by genres;

#4. Check for null values in the data and replace it with NA
Select count(*) from links where tmdbId is null limit 100000 ; 
UPDATE links SET tmdbId = "NA" WHERE tmdbId is null;

#5. How many movies were produced per year? 
Select count(*) from movies;
select count(*) as count,years from (select title,  SUBSTRING_INDEX(SUBSTRING_INDEX(title,'(',-1),')',1) as years from movies) a where years between '0000' and '3000' group by years;

#6. What were the most popular movie genres year by year?  
select max(count) as numOfMovies,years,genres from 
(select count(*) as count,years,genres from 
(select title,  SUBSTRING_INDEX(SUBSTRING_INDEX(title,'(',-1),')',1) as years, genres from movies) a
where years between '0000' and '3000'  group by years) as countGenre group by years;




#7. What tags best summarize a movie genre? 
Create table splitYear as SELECT *,SUBSTRING_INDEX(SUBSTRING_INDEX(title,'(',1),')',1) AS only_title, SUBSTRING_INDEX(SUBSTRING_INDEX(title,'(',-1),')',1)  AS years from movies order by movieid;

select * from splitYear;

select title, genres, count(tag) from tags join movies on tags.movieId=movies.movieId order by tag desc;




#8. What were the best movies of every decade (based on users’ ratings)?  

SELECT distinct title,  years,
		CASE WHEN years = 'NA' THEN 'NA'
		WHEN years < 2000 and years > 1989 THEN '1990s'
		WHEN years < 2010 and years > 1999 THEN '2000s'
		WHEN years < 2020 and years > 2009 THEN '2010s'
		ELSE NULL END AS decade,genres,rating FROM  splitYear join ratings
on splitYear.movieId = ratings.movieId limit 5 ;



INSERT INTO splityear
SELECT * FROM ratings;

SELECT * FROM splityear;
#9. Plot distribution of Users’ Ages 
select age, count(*) as num
from users group by age;


#10. Find ratings by age group 
Select ratings_id, rating, age
from ratings join users
on users.userid = ratings.userid order by age desc;

Select ratings_id, rating, age
from ratings join users
on users.userid = ratings.userid where age = 25;

#11. Find Ratings by Occupation 
Select ratings_id, rating, occupation
from ratings join users
on users.userid = ratings.userid order by occupation desc;

Select ratings_id, rating, occupation
from ratings join users
on users.userid = ratings.userid where occupation = 5;

#12. Find Ratings By State 
Select ratings_id, rating, zipcode
from ratings join users
on users.userid = ratings.userid order by zipcode desc;

Select ratings_id, rating, zipcode
from ratings join users
on ratings.userid = users.userid where zipcode = 193122042;

#13. Find Ratings by Income
Select ratings_id, rating, income
from ratings join users
on users.userid = ratings.userid order by income desc;


Select ratings_id, rating, income
from ratings join users
on users.userid = ratings.userid where income > 2000;







#show every different value of occupation from the users table
select distinct occupation from users;

#Take the average rating, and the occupation from the ratings and users table where the occupation is 14
Select avg(rating), occupation from ratings join users on ratings.userId = users.userId where occupation = 14;

#Combine movie id and imdb id into one table where the movie id is within the range given below
Select concat(movieId) as movieid,imdbid   from links where movieId > 100000 and movieId < 100004 ;

#Select the imdb id and title from the movies and links tables where the movie id is within the range given below
Select imdbId, title from movies join links on movies.movieId = links.movieId where movies.movieId > 100000 and movies.movieId < 100004;

#Select zipcode and the count of  the same zipcode where the age is within range, display the text set to each range while grouped by the zipcode having a count in the range between 1 and 4 (2 and 3 only)
select zipcode, count(zipcode), case when age < 26 then 'young' when age >26 then 'old' when age =26 then 'perfect age' end from users group by zipcode having count(*) > 1 and count(*)< 4 ;


#Select rows specified from genomescores where the genomescore id is within range given below and is not null
Select movieId, genomescoreid, tagId from genomescores where genomescoreid <1130 and genomescoreid > 1128 and genomescoreid is not null;


#Select all and count the genres from movies where the genres are blank
select *,count(genres) from movies where genres = '';






