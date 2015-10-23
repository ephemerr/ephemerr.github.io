#!/usr/bin/lua

local tools        = require"atools"
local unpack     = tools.unpack   
local next_fltr    = tools.next_fltr 
local pairs_fltr   = tools.pairs_fltr

local function dataload(name)
    local chunk = {}
    table.insert(chunk, name)
    table.insert(chunk, "={")
    table.insert(chunk, io.open("../data/"..name..".lua", "r"):read("*all"))
    table.insert(chunk, "}")
    chunk=table.concat(chunk)
    loadstring(chunk)()
end

dataload("shows")
dataload("plays")
dataload("stages")
dataload("news")

local out = io.open("../sql/shows.csv","w");
out:write("id,stage,play,date,time\n")
for i = 1,#shows do
    local id, month, day, wday, time, playid, stageid = unpack(shows[i])
    local line = string.format("%d,%s,%s,2015-%d-%d,%s\n",i,playid,stageid,tools.mnum(month),day,time)
    out:write(line)
end

io.close(out)
out = io.open("../sql/plays.csv","w");
out:write("id,short,title,author,descr,age,isalive,premiere,creator\n")
for i = 1,#plays do
    local playid, playname, about, descr, age, status = unpack(plays[i])
    local line = string.format("%d,%s,'%s','%s','%s',%s,%d,NULL,NULL\n",i,playid, playname,about,descr,age, status == 'alive' and 1 or 0)
    out:write(line)
end

io.close(out)
out = io.open("../sql/stages.csv","w");
out:write("id,short,station,place,addr\n")
for i = 1,#stages do
    local id, station, place, addr = unpack(stages[i])
    local line = string.format("%d,%s,'%s','%s','%s'\n",i,id,station,place,addr )
    out:write(line)
end

io.close(out)
out = io.open("../sql/news.csv","w");
out:write("id,data,text\n")
for i = 1,#news do
    local data, text = unpack(news[i])
    local line = string.format("%d,%s,'%s'\n",i,data,text )
    out:write(line)
end
