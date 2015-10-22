local inspect = require"inspect"

local drive = require"luasql.mysql"
local env = assert (drive.mysql())
local con = assert (env:connect("theater","root","123456","localhost",3306 ))

local q = io.open("q.sql","r"):read("*all") 
local cur = assert(con:execute(q))
local title,age = cur:fetch()

print(cur:fetch())
print(cur:fetch())
