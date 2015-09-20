#!/usr/bin/lua

module("gen",package.seeall)

local haml         = require "haml"
local options      = {format = "html5"}
local engine       = haml.new(options)
local locals = {}

--    [1] pagename  [2] title        [3] parent
local pages =  {
    {  "index"   , "Пустая страница", "root"   }, 
    {  "main"    , "Главная"        , "root"   },
    {  "theatre" , "О театре"       , "theatre"},
    {  "hist"    , "История"        , "theatre"},
    {  "genre"   , "Наш жанр"       , "theatre"},
    {  "rucov"   , "Руководитель"   , "theatre"},
    {  "plays"   , "Афиша"          , "plays"  },
    {  "playinfo", "Репертуар"      , "plays"  },                
    {  "study"   , "Студия"         , "study"  },
    {  "method"  , "Методики"       , "study"  },
    {  "contact" , "Контакты"       , "contact"},
}

local sections = {
   { "theatre"   , "О театре"   },
   { "plays"     , "Спектакли"  },
   { "study"     , "Студия"     },
   { "contact"   , "Контакты"   },
} 

local function dataload(name) 
    local chunk = name .. "={"
    chunk = chunk .. io.open("../data/"..name..".lua", "r"):read("*all")
    chunk = chunk .. "}"
    loadstring(chunk)()
end

dataload("playbill")
dataload("playinfo")
dataload("news")

function ilements(tab, from) 
    local from = from or 1    
    if not tab[from] then return end
    return tab[from], ilements(tab,from+1)
end

local function next_fltr(fltr, from)
    local from = from or 0    
    tab, col, val = ilements(fltr)
    for i = from+1,#tab do
        if tab[i][col] == val then return i, tab[i] end
    end
end

function pairs_fltr(tab, col, val)
    return next_fltr, {tab, col, val}, 0
end


local function elem( el_name )  
    local el_haml = "../elem/" .. el_name .. ".haml"
    local res = engine:render_file(el_haml, locals)
    return res
end
locals.elem = elem

locals.nav = function()
    res = {}
    for k,v in pairs(sections) do
        local section,title = ilements(v)
        locals.file = "/html/"..section..".html"
        locals.title = title
        _,page = next_fltr({pages,1,locals.name},0)
        locals.current = page[3] == section and "current" or ""
        table.insert(res, elem("links"))
    end
    return table.concat(res)
end

locals.links = function()
    res = {}
    for k,v in pairs_fltr(pages, 3, locals.section) do
        local name, title, section = ilements(v)
        locals.file = "/html/"..name..".html"
        locals.title = title        
        locals.current = locals.name == name and "current" or ""
        table.insert(res, elem("links"))
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
        table.insert(res, elem("news"))
    end
    return table.concat(res)
end

locals.playbill = function(max)
    max = max or 1
    local res = {}    
    for i=1,max do 
        locals.month,       locals.day,   locals.time,    
        locals.age,         locals.about, locals.playname,   
        locals.station,     locals.place, locals.addr   = ilements(playbill[i])
        table.insert(res, elem("playbill"))
    end
    return table.concat(res)
end

locals.playinfo = function()    
    local res = {} 
    for i=1,#playinfo do 
        locals.playname, locals.title, locals.short, locals.long   = ilements(playinfo[i])
        locals.imgsrc = "/img/playinfo/"..locals.playname.."/1_min.jpg"
        table.insert(res, elem("playinfo"))
    end
    return table.concat(res)
end

function genpage(name)
    local _,page = next_fltr{pages,1,name} 
    page = page or pages[1]
    local _, title, section = ilements(page)
    locals.section = section
    locals.name = name
    local template = section == "root" and "../haml/template.haml" or "../haml/template_second.haml"
    local rendered = engine:render_file(template, locals)
    return rendered
end

function genall()
    for k,v in pairs(pages) do
        local name, title, section = ilements(v)
        html_name = name == "main" and "../index.html" or "../html/"..name..".html"
        local p = genpage(name)
        io.open(html_name,"w+"):write(p);
    end
end

return _M