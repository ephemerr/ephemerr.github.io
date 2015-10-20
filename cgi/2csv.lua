#!/usr/bin/lua

local tools        = require"atools"
local ilements     = tools.ilements   
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

local month = {
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь'
}

local function mnum(mname)
    for i = 1,#month do
        if month[i] == mname then return i end
    end
end

local out = io.open("../data/shows.csv","w");
out:write("id,stage,play,date,time\n")
for i = 1,#shows do
    local id, month, day, wday, time, playid, stageid = ilements(shows[i])
    local line = string.format("%d,%s,%s,2015-%d-%d,%s\n",i,playid,stageid,mnum(month),day,time)
    out:write(line)
end

io.close(out)
out = io.open("../data/plays.csv","w");
out:write("id,title,author,descr,age,isalive,premiere,creator\n")
for i = 1,#plays do
    local playid, playname, about, descr, age, status = ilements(plays[i])
    local line = string.format("%s,'%s','%s','%s',%s,%d,NULL,NULL\n",playid, playname,about,descr,age, status == 'alive' and 1 or 0)
    out:write(line)
end

io.close(out)
out = io.open("../data/stages.csv","w");
out:write("id,station,place,addr\n")
for i = 1,#stages do
    local id, station, place, addr = ilements(stages[i])
    local line = string.format("%s,'%s','%s','%s'\n",id,station,place,addr )
    out:write(line)
end




