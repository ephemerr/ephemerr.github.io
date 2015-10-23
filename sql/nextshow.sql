SELECT
  play.short,
  play.title,
  play.author,
  play.age,
  play.isalive,
  stage.station,
  stage.place,
  stage.addr,
  stage.short,
  DATE_FORMAT (`show`.`date`, "%a") as weekday,
  DATE_FORMAT (`show`.`date`, "%e") as day,
  DATE_FORMAT (`show`.`date`, "%M") as month,
  TIME_FORMAT (`show`.`time`, "%k:%i") as time
  FROM
    `show`
    JOIN
        (play,stage)
        ON (`show`.stage = stage.short  AND  `show`.play = play.short)
  WHERE `show`.`date` >= CURRENT_DATE()
  LIMIT 1;
