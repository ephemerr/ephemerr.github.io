#!/usr/bin/lua

local inspect = require "inspect"

module("gen",package.seeall)

local haml         = require "haml"
local options      = {format = "html5"}
local engine       = haml.new(options)

local tools        = require "atools"
local next_fltr    = tools.next_fltr
local pairs_fltr   = tools.pairs_fltr

local locals = {}

local drive = require"luasql.mysql"
local env = assert (drive.mysql())
local mysql = assert (env:connect("theater","root","123456","localhost",3306 ))


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

--dataload("shows")
dataload("plays")
dataload("stages")
dataload("news")

local function query(name)
    return "SELECT * FROM "..name..";";
end

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
        local section,title = unpack(v)
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
        local name, title, section = unpack(v)
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
        locals.date, locals.newshead, locals.newsbody = unpack(news[i])
        table.insert(res, haml("news"))
    end
    return table.concat(res)
end

locals.places = function()
    res={}
    for i=1,#stages do
        local stageid, station, place, addr = unpack(stages[i])
        locals.station = station
        locals.place   = place
        locals.addr    = addr
        locals.stageid = stageid
        locals.placemap = "/img/stages/"..stageid..".jpg"
        table.insert(res, haml("addr"))
    end
    return table.concat(res)
end

locals.playlabel = function()
        if locals.isalive == '1' then
            locals.page =  "/html/playinfo.html#"..locals.playid
            return haml('a')
        else
            return locals.text
        end
end

local function playbill()
    locals.month    =   tools.month[locals.month]
    locals.weektime =   tools.wday[locals.weekday]..' '.. locals.time
    locals.text     =   locals.title
    locals.stage    =   "/html/addr.html#"..locals.stageid
    return haml("playbill")
end

locals.nextshow = function()
    local cursor = assert(mysql:execute(query("nextshow")))
    if cursor:fetch(locals, "a") then
        return playbill()
    end
end

locals.playbill = function()
    local cursor = assert(mysql:execute(query("playbill")))
    local res={}
    while cursor:fetch(locals, "a") do
        table.insert(res,playbill())
    end
    return table.concat(res)
end

locals.playinfo = function()
    local cursor = assert(mysql:execute(query("playinfo")))
    local res = {}
    while cursor:fetch(locals, "a") do
        locals.label = '"' .. locals.label .. '"'
        locals.imgname = "playinfo/"..locals.short .."/1"
        table.insert(res, haml("playinfo"))
    end
    return table.concat(res)
end

function genpage(name)
    local _,page = next_fltr{pages,1,name}
    page = page or pages[1]
    local _, title, section = unpack(page)
    locals.section = section
    locals.name = name
    local rendered = section == "root" and haml("page") or haml("page2") --MOCK
    return rendered
end

function genall()
    for k,v in pairs(pages) do
        local name, title, section = unpack(v)
        local html_name = name == "main" and "../index.html" or "../html/"..name..".html"
        local p = genpage(name)
        io.open(html_name,"w+"):write(p);
    end
end

return _M
