#sqlite commands for the betterflickr database
CREATE TABLE User(
 username    VARCHAR(31) UNIQUE NOT NULL,
 nsid	     VARCHAR(31) UNIQUE NOT NULL,
 main_user   BOOL NOT NULL DEFAULT 0,
 
 PRIMARY KEY (nsid)
 
);

CREATE TABLE Photos(
 farm        INTEGER NOT NULL,
 id			 VARCHAR(31) UNIQUE NOT NULL,
 ispublic    BOOL NOT NULL DEFAULT 1,
 owner	     VARCHAR(31) NOT NULL,
 secret      VARCHAR(31) NOT NULL,
 server      INTEGER NOT NULL,
 title       VARCHAR(31) NOT NULL,

 description TEXT DEFAULT NULL,
 posted      INTEGER DEFAULT NULL,
 updated     INTEGER DEFAULT NULL,
 taken       VARCHAR(31) DEFAULT NULL,
 path        VARCHAR(255) DEFAULT NULL,

 views       INTEGER DEFAULT NULL,
 comments    INTEGER DEFAULT NULL,
 favourites  INTEGER DEFAULT NULL,
 
 PRIMARY KEY (id)
 
);