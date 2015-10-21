#!/usr/bin/lua

--local inspect = require "inspect"

module("gen",package.seeall)

local haml         = require "haml"
local options      = {format = "html5"}
local engine       = haml.new(options)

local tools        = require "atools"
local ilements     = tools.ilements   
local next_fltr    = tools.next_fltr 
local pairs_fltr   = tools.pairs_fltr

local locals = {}

--    [1] pagename  [2] title        [3] parent
local pages =  {
    {  "index"   , "Пустая страница", "root"   },
    {  "main"    , "Главная"        , "root"   },
    {  "error"   , "Не найдено"     , "root"   },
    {  "theatre" , "Коротко"        , "theatre"},
    {  "genre"   , "Жанр"           , "theatre"},
    {  "hist"    , "История"        , "theatre"},
    {  "rucov"   , "Руководитель"   , "theatre"},
    {  "plays"   , "Афиша"          , "plays"  },
    {  "playinfo", "Репертуар"      , "plays"  },
    {  "study"   , "Молодежная"     , "study"  },
    {  "study"   , "Взрослая"       , ""  },
    {  "method"  , "Методики"       , ""  },
    {  "contact" , "Контакты"       , "contact"},
    {  "addr"    , "Адреса"         , "contact"},
}

local sections = {
   { "theatre"   , "О нас"   },
   { "plays"     , "Спектакли"  },
   { "study"     , "Студия"     },
   { "contact"   , "Контакты"   },
}

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



---- API

locals.script = function(scriptname)
    return io.open("/js/"..scriptname..".js","r"):read("*all")
end

local function haml( el_name )
    local el_haml = "../haml/" .. el_name .. ".haml"
    local res = engine:render_file(el_haml, locals)
    return res
end
locals.haml = haml

local function img(imgname)
    locals.imgname = imgname
    locals.imgmini = "/img/".. imgname .. "_min.jpg"
    locals.imgmaxi = "/img/".. imgname .. "_max.jpg"
    return haml("img")
end
locals.img = img

locals.map = function()
    local res = {}
    local cur_section = locals.section
    for k,v in pairs(sections) do
        if k % 2 == 1 then table.insert(res,'\n<div>\n') end 
        local section,title = ilements(v)
        locals.section = section
        locals.s_file = "/html/"..section..".html"
        locals.s_title = title
        _,page = next_fltr{pages,1,locals.name}
        locals.current = page[3] == section and "current" or ""
        table.insert(res, haml("section"))
        if k % 2 == 0 then table.insert(res,'\n</div>\n') end 
    end
    locals.section = cur_section -- restore
    return table.concat(res)
end

locals.links = function()
    local res = {}
    for k,v in pairs_fltr(pages, 3, locals.section) do
        local name, title, section = ilements(v)
        locals.file = "/html/"..name..".html"
        locals.title = title
        locals.current = locals.name == name and "current" or ""
        table.insert(res, haml("links"))
    end
    return table.concat(res)
end

locals.css = function()
    local cssfile = "/css/"..locals.name..".css"
    local is = io.open("../"..cssfile,"r")
    return is and cssfile or "/css/index.css"
end

locals.content = function()
    local haml = "../cont/"..locals.name..".haml"
    if not io.open(haml, "r") then return "" end
    local res = engine:render_file(haml, locals)
    return res
end

locals.topnews = function(max)
    local res = {}
    for i=1,max do
        locals.date, locals.newshead, locals.newsbody = ilements(news[i])
        table.insert(res, haml("news"))
    end
    return table.concat(res)
end

locals.playlabel = function()
        if locals.status == 'alive' then
            locals.page =  "/html/playinfo.html#"..locals.playid
            return haml('a')
        else
            return locals.text
        end
end

locals.places = function()
    res={}
    for i=1,#stages do
        local stageid, station, place, addr = ilements(stages[i])
        locals.station = station 
        locals.place   = place   
        locals.addr    = addr    
        locals.placemap = "/img/stages/"..stageid..".jpg" 
        table.insert(res, haml("addr"))
    end
    return table.concat(res)
end

local function show(i)
        local _, month, day, wday, time, playid, stageid = ilements(shows[i])
        local _, play  = next_fltr{plays, 1, playid}
        local _, stage = assert(next_fltr{stages, 1, stageid})
        local playid, playname, about, _, age, status = ilements(play)
        local _, station, place, addr = ilements(stage)
        locals.month    =   month
        locals.day      =   day
        locals.weektime =   wday..' '..time
        locals.age      =   age
        locals.about    =   about
        locals.playname =   playname
        locals.station  =   station
        locals.place    =   place
        locals.addr     =   addr
        locals.text     =   playname
        locals.playid   =   playid
        locals.status   =   status
        return haml("playbill")
end

locals.nextshow = function()
    local i = next_fltr{shows, 1, 0}
    return show(i)
end

locals.playbill = function(past, future)
    local nexti = next_fltr{shows, 1, 0}
    local from = nexti - past
    from = from > 0 and from or 1
    local til  = nexti + future-1
    til = til < #shows and til or #shows
    local res={}
    for i = from,til do
        table.insert(res,show(i))
    end
    return table.concat(res)
end

locals.playinfo = function()
    local res = {}
    for i=1,#plays do
        local status
        locals.playname, locals.title, locals.short, locals.long, locals.age, status  = ilements(plays[i])
        if status == 'alive' then
            locals.title = '"' .. locals.title .. '"'
            locals.imgname = "playinfo/"..locals.playname.."/1"
            table.insert(res, haml("playinfo"))
        end
    end
    return table.concat(res)
end

function genpage(name)
    local _,page = next_fltr{pages,1,name}
    page = page or pages[1]
    local _, title, section = ilements(page)
    locals.section = section
    locals.name = name
    local rendered = section == "root" and haml("page") or haml("page2") --MOCK
    return rendered
end

function genall()
    for k,v in pairs(pages) do
        local name, title, section = ilements(v)
        local html_name = name == "main" and "../index.html" or "../html/"..name..".html"
        local p = genpage(name)
        io.open(html_name,"w+"):write(p);
    end
end

return _M
