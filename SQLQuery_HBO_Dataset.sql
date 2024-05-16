SELECT *
FROM dbo.HBO_Dataset_PRESQL;


-- ADD ID COLUMN
/* 
Some movies have remake versions (e.g., Casino Royale (2006) and Casino Royale (1967)), 
so I added an ID field to each movie to establish a primary key, which will facilitate future queries.
*/


ALTER TABLE dbo.HBO_Dataset_PRESQL 
ADD ID INT IDENTITY(1, 1) PRIMARY KEY;


-- CREATING AN AUX TABLE TO SIMPLIFY THE GENRE COUNT
/* 
The genres are represented in boolean columns, where each genre type is a field. If a movie belongs to a particular genre,
it's assigned a value of 1; otherwise, it's assigned a value of 0. To facilitate the counting of genres, I've created the following table.
*/


SELECT * FROM genre_count ORDER BY ID;


SELECT 
    ID,
    Title,
    'Action/Adventure' AS Genre
INTO 
    genre_count
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Action_Adventure = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Animation' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Animation = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Anime' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Anime = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Biography' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Biography = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Children' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Children = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Comedy' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Comedy = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Crime' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Crime = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Cult' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Cult = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Documentary' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Documentary = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Drama' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Drama = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Family' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Family = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Fantasy' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Fantasy = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Food' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Food = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Game/Show' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Game_Show = 1

UNION ALL

SELECT 
    ID,
    Title,
    'History' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_History = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Home/Garden' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Home_Garden = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Horror' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Horror = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Independent' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Independent = 1

UNION ALL

SELECT 
    ID,
    Title,
    'LGBTQ' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_LGBTQ = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Musical' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Musical = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Mystery' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Mystery = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Reality' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Reality = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Romance' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Romance = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Science Fiction' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Science_Fiction = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Sport' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Sport = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Stand Up Talk' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Stand_up_Talk = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Thriller' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Thriller = 1

UNION ALL

SELECT 
    ID,
    Title,
    'Travel' AS Genre
FROM 
    dbo.HBO_Dataset_PRESQL
WHERE 
    genres_Travel = 1;


SELECT Genre,
COUNT (GENRE) AS count_genre
FROM genre_count
GROUP BY Genre
ORDER BY count_genre DESC;


-- CREATING A RANKING TABLE BY IMDB SCORE
-- In case of tie scores, movies are ordered alphabetically.


SELECT 
    ID,
    title,
    imdb_score,
    DENSE_RANK() OVER (ORDER BY imdb_score DESC, title ASC) AS ranking

INTO
    ranking
FROM dbo.HBO_Dataset_PRESQL

SELECT * 
FROM ranking













