SELECT 
  play.title,
  play.author,
  stage.station,
  stage.place,
  stage.addr,
  `show`.`date`,
  `show`.`time`
    FROM 
        `show` 
        JOIN 
            (play,stage)
            ON (`show`.stage = stage.id  AND  `show`.play = play.id);
