DROP DATABASE IF EXISTS theater;
CREATE DATABASE theater CHARACTER SET = utf8 COLLATE = utf8_general_ci;
USE theater;

CREATE TABLE person (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` CHAR(70) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE `play` (
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
) CHARACTER SET = utf8 COLLATE = utf8_general_ci;

CREATE TABLE `stage` (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	short VARCHAR(20) NOT NULL UNIQUE,
    station VARCHAR(255),
    place VARCHAR(255) NOT NULL,
    addr VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (id)
) CHARACTER SET = utf8 COLLATE = utf8_general_ci;

CREATE TABLE `show`(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    play VARCHAR(20) NOT NULL REFERENCES play(id),
    stage VARCHAR(20) NOT NULL REFERENCES stage(id),
    `date` DATE NOT NULL,
    `time` TIME NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET = utf8 COLLATE = utf8_general_ci;

LOAD DATA INFILE '/home/azzel/soft/ephemerr.github.io/data/plays.csv'
INTO TABLE `play`
FIELDS OPTIONALLY ENCLOSED BY '\'' TERMINATED BY ','
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA INFILE '/home/azzel/soft/ephemerr.github.io/data/stages.csv'
INTO TABLE `stage`
FIELDS OPTIONALLY ENCLOSED BY '\'' TERMINATED BY ','
LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA INFILE '/home/azzel/soft/ephemerr.github.io/data/shows.csv'
INTO TABLE `show`
FIELDS OPTIONALLY ENCLOSED BY '\'' TERMINATED BY ','
LINES TERMINATED BY '\n' IGNORE 1 LINES;


CREATE VIEW playbill AS SELECT
    play.short as playid,
    play.title,
    play.author,
    play.age,
    play.isalive,
    stage.station,
    stage.place,
    stage.addr,
    stage.short as stageid,
    `show`.`date`,
    DATE_FORMAT (`show`.`date`, "%a") as weekday,
    DATE_FORMAT (`show`.`date`, "%e") as day,
    DATE_FORMAT (`show`.`date`, "%M") as month,
    TIME_FORMAT (`show`.`time`, "%k:%i") as time
    FROM
      `show`
      JOIN
          (play,stage)
          ON (`show`.stage = stage.short  AND  `show`.play = play.short)
;

CREATE VIEW nextshow AS SELECT * FROM playbill
    WHERE playbill.`date` >= CURRENT_DATE()
    LIMIT 1
;

CREATE VIEW playinfo AS SELECT
    play.short,
    play.title as label,
    play.author,
    play.descr,
    play.age
    FROM play 
    WHERE play.isalive = 1
; 
