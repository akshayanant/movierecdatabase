CREATE TABLE users(
	userid INT NOT NULL,
	name TEXT,
	PRIMARY KEY (userid)
);

CREATE TABLE movies(
	movieid INT NOT NULL,
	title TEXT,
	PRIMARY KEY (movieid)
);

CREATE TABLE taginfo(
	tagid INT NOT NULL,
	content TEXT,
	PRIMARY KEY (tagid)
);

CREATE TABLE genres(
	genreid INT NOT NULL,
	name TEXT,
	PRIMARY KEY (genreid)
);

CREATE TABLE ratings(
	userid INT NOT NULL,
	movieid INT NOT NULL,
	rating NUMERIC NOT NULL CHECK(rating>=0) CHECK(rating<=5),
	timestamp TIMESTAMP,
	PRIMARY KEY (userid,movieid),
	FOREIGN KEY (userid) REFERENCES users ON DELETE CASCADE,
	FOREIGN KEY (movieid) REFERENCES movies ON DELETE CASCADE
);

CREATE TABLE tags(
	userid INT NOT NULL,
	movieid INT NOT NULL,
	tagid INT NOT NULL,
	timestamp TIMESTAMP,
	PRIMARY KEY (userid,movieid,timestamp),
	FOREIGN KEY (userid) REFERENCES users ON DELETE CASCADE,
	FOREIGN KEY (movieid) REFERENCES movies ON DELETE CASCADE,
	FOREIGN KEY (tagid) REFERENCES taginfo ON DELETE CASCADE
);

CREATE TABLE hasagenre(
	movieid INT NOT NULL,
	genreid INT NOT NULL,
	PRIMARY KEY (movieid,genreid),
	FOREIGN KEY (movieid) REFERENCES movies ON DELETE CASCADE,
	FOREIGN KEY (genreid) REFERENCES genres ON DELETE CASCADE
)

