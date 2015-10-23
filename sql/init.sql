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

