local inspect = require"inspect"
local drive = require"luasql.mysql"
local env = assert (drive.mysql())
local con = assert (env:connect("theater","root","123456","localhost",3306 ))

local q = [[
    USE theater;
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
        JOIN (stage, play)
        ON (`show`.stage = stage.id  AND  `show`.play = play.id);
]]

local qq = 'SELECT play.title, play.age FROM play;'

local cur = assert(con:execute(qq))
--local res,r = cur:fetch()
print(cur:fetch())
