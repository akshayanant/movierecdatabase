CREATE TABLE query1 AS(
	SELECT
		G.name,
		COUNT(*) moviecount
	FROM
		genres G
		INNER JOIN hasagenre H
		ON G.genreid=H.genreid
	GROUP BY 
		G.name
	ORDER BY 
		G.name
);



CREATE TABLE query2 AS(
	SELECT 
		G.name,
		AVG(rating) rating
	FROM 
		ratings R
		INNER JOIN movies M
			ON R.movieid=M.movieid
		INNER JOIN hasagenre H
			ON H.movieid=M.movieid
		INNER JOIN genres G
			ON G.genreid = H.genreid
	GROUP BY
		G.name
	ORDER BY
		G.name
);



CREATE TABLE query3 AS(
	SELECT
		M.title,
		COUNT(rating) countofratings
	FROM
		movies M
		INNER JOIN ratings R
			ON M.movieid=R.movieid
	GROUP BY
		M.title
	HAVING
		COUNT(rating)>9
	ORDER BY 
		M.title
);


CREATE TABLE query4 as (
	SELECT 
		M.movieid,
		M.title
	FROM 
		movies M
		INNER JOIN hasagenre H
			ON H.movieid = M.movieid
		INNER JOIN genres G
			ON H.genreid = G.genreid
	WHERE
		G.name = 'Comedy'
	ORDER BY 
		M.movieid
);


CREATE TABLE query5 AS(
	SELECT
		M.title,
		AVG(rating) average
	FROM 
		movies M
		INNER JOIN ratings R
			ON M.movieid = R.movieid
	GROUP BY
		M.title
	ORDER BY
		M.title
);


CREATE TABLE query6 AS(
	SELECT
		AVG(rating) average
	FROM 
		movies M
		INNER JOIN ratings R
			ON M.movieid = R.movieid
		INNER JOIN hasagenre H
			ON H.movieid = M.movieid
		INNER JOIN genres G
			ON H.genreid = G.genreid
	WHERE
		G.name = 'Comedy'
);



CREATE TABLE query7 AS(
	SELECT
		AVG(rating) average
	FROM 
		Ratings R
	WHERE
		R.movieid IN(
			SELECT 
				M2.movieid
			FROM 
				movies M2
				INNER JOIN Ratings R1
					ON R1.movieid=M2.movieid
				INNER JOIN hasagenre H1
					ON H1.movieid=M2.movieid
				INNER JOIN genres G1
					ON G1.genreid = H1.genreid
			WHERE
				G1.name = 'Comedy'
		)
		AND
		R.movieid IN(
			SELECT 
				M3.movieid
			FROM 
				movies M3
				INNER JOIN Ratings R2
					ON R2.movieid=M3.movieid
				INNER JOIN hasagenre H2
					ON H2.movieid=M3.movieid
				INNER JOIN genres G2
					ON G2.genreid = H2.genreid
			WHERE
				G2.name = 'Romance'
		)		
);


CREATE TABLE query8 AS(
	SELECT
		AVG(rating) average
	FROM 
		Ratings R
	WHERE
		R.movieid IN(
			SELECT 
				M2.movieid
			FROM 
				movies M2
				INNER JOIN Ratings R1
					ON R1.movieid=M2.movieid
				INNER JOIN hasagenre H1
					ON H1.movieid=M2.movieid
				INNER JOIN genres G1
					ON G1.genreid = H1.genreid
			WHERE
				G1.name = 'Romance'
		)
		AND
		R.movieid NOT IN(
			SELECT 
				M3.movieid
			FROM 
				movies M3
				INNER JOIN Ratings R2
					ON R2.movieid=M3.movieid
				INNER JOIN hasagenre H2
					ON H2.movieid=M3.movieid
				INNER JOIN genres G2
					ON G2.genreid = H2.genreid
			WHERE
				G2.name = 'Comedy'
		)		
);



CREATE TABLE query9 AS (
	SELECT 
		M.movieid,
		R.rating
	FROM
		movies M
		INNER JOIN ratings R
			ON M.movieid = R.movieid
		INNER JOIN users U
			ON U.userid = R.userid
	WHERE
		U.userid = :v1
);



CREATE VIEW sim AS(
	SELECT 
		M1.movieid movieid1,
		M2.movieid movieid2,
		1-ABS(AVG(R1.rating) - AVG (R2.rating))/5 sim
	FROM 
		movies M1
		INNER JOIN ratings R1
			ON R1.movieid = M1.movieid
		INNER JOIN movies M2
			ON 1=1
		INNER JOIN ratings R2
			ON M2.movieid=R2.movieid
	GROUP BY 
		M1.movieid,M2.movieid
	ORDER BY 
		M1.movieid
);


CREATE TABLE recommendation AS(
	SELECT 
		DISTINCT ON (M.title) title		
	FROM 
		movies M
		INNER JOIN sim S
			ON M.movieid=S.movieid1
		INNER JOIN ratings R1
			ON S.movieid1 = R1.movieid AND R1.userid!=:v1
		INNER JOIN ratings R2
			ON S.movieid2 = R2.movieid AND R2.userid=:v1

	GROUP BY
		M.title
	HAVING
		SUM(S.sim*R2.rating)/SUM(S.sim) > 3.9
);