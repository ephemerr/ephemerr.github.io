local inspect = require"inspect"

local u = assert(require'utf8').u
local u2s = assert(require'utf8').u2s

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

os.setlocale("C",all)
local cur = assert(con:execute(qq))
local title,age = cur:fetch()

print(cur:fetch())
local _, count = string.gsub(title, "[^\128-\193]", "")

print ("count ", count)
print (os.setlocale())

print (""..inspect(u2s(title)))
