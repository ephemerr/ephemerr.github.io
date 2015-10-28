DROP DATABASE IF EXISTS theater;
CREATE DATABASE theater CHARACTER SET = utf8 COLLATE = utf8_general_ci;
USE theater;

SET @@lc_time_names='ru_RU';

CREATE TABLE person (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name CHAR(70) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE play (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	short VARCHAR(20) NOT NULL UNIQUE,
    title TEXT(4096) NOT NULL,
    author VARCHAR(255) NOT NULL,
    descr TEXT NOT NULL,
    age CHAR(5),
    isalive BOOL,
    premiere DATE,
    creator VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE stage (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	short VARCHAR(20) NOT NULL UNIQUE,
    station VARCHAR(255),
    place VARCHAR(255) NOT NULL,
    addr VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE `show`(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    play VARCHAR(20) NOT NULL REFERENCES play(id),
    stage VARCHAR(20) NOT NULL REFERENCES stage(id),
    `date` DATE NOT NULL,
    `time` TIME NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE news (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `date` DATE NOT NULL,
    `text` VARCHAR(512) NOT NULL,
    PRIMARY KEY (id)
);

LOAD DATA INFILE '/home/azzel/soft/ephemerr.github.io/sql/plays.csv'
INTO TABLE `play`
FIELDS OPTIONALLY ENCLOSED BY '\'' TERMINATED BY ','
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA INFILE '/home/azzel/soft/ephemerr.github.io/sql/stages.csv'
INTO TABLE `stage`
FIELDS OPTIONALLY ENCLOSED BY '\'' TERMINATED BY ','
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA INFILE '/home/azzel/soft/ephemerr.github.io/sql/shows.csv'
INTO TABLE `show`
FIELDS OPTIONALLY ENCLOSED BY '\'' TERMINATED BY ','
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA INFILE '/home/azzel/soft/ephemerr.github.io/sql/news.csv'
INTO TABLE `news`
FIELDS OPTIONALLY ENCLOSED BY '\'' TERMINATED BY ','
LINES TERMINATED BY '\n' IGNORE 1 LINES;

CREATE VIEW playbill AS SELECT
    play.title,
    play.author,
    play.age,
    IF (play.isalive = '1', 
        CONCAT("/html/playinfo.html#",play.short),
        ""
    ) as playlink,
    stage.station,
    stage.place,
    stage.addr,
    CONCAT("/html/addr.html#",stage.short) as stage,
    `show`.`date`,
    DATE_FORMAT (`date`, "%e") as day,
    DATE_FORMAT (`date`, "%M") as month,
    CONCAT(
        MID(DATE_FORMAT(`date`, "%a"),1,2),
        " ",
        TIME_FORMAT(`time`, "%k:%i")
        ) as weektime
    FROM
      `show`
      JOIN
          (play,stage)
          ON (`show`.stage = stage.short  AND  `show`.play = play.short)
;

CREATE VIEW nextshow AS SELECT * FROM playbill
    WHERE `date` >= CURRENT_DATE()
    LIMIT 1
;

CREATE VIEW playinfo AS SELECT
    short,
    title as label,
    author,
    descr,
    CONCAT("playinfo/",short,"/1") as imgname,
    age
    FROM play 
    WHERE play.isalive = 1
; 

CREATE VIEW placeinfo AS SELECT
    short as stageid, 
    station, 
    place, 
    CONCAT("/img/stages/", short,".jpg") as placemap,
    addr
    FROM stage
;

CREATE VIEW newsletter AS SELECT
    DATE_FORMAT (`date`, "%e.%m.%Y") as date,
    text
    FROM news
    LIMIT 3 
;
