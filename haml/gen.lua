#!/usr/bin/lua

local haml         = require "haml"
local options      = {format = "html5"}
local engine       = haml.new(options)
local locals = {}

--     page       title               parent
local pages =  {
    {  "index"   , "Пустая страница", "root"   }, 
    {  "main"    , "Главная"        , "root"   },
    {  "theatre" , "О театре"       , "theatre"},
    {  "hist"    , "История"        , "theatre"},
    {  "genre"   , "Наш жанр"       , "theatre"},
    {  "rucov"   , "Руководитель"   , "theatre"},
    {  "plays"   , "Афиша"          , "plays"  },
    {  "allplays", "Репертуар"      , "plays"  },                
    {  "study"   , "Студия"         , "study"  },
    {  "method"  , "Методики"       , "study"  },
    {  "reqruit" , "Набор"          , "study"  },
    {  "contact" , "Контакты"       , "contact"},
}

local sections = {
   { "theatre"   , "О театре"   },
   { "plays"     , "Спектакли"  },
   { "study"     , "Студия"     },
   { "contact"   , "Контакты"   },
} 

loadstring(io.open("../data/playbill.lua", "r"):read("*all"))()
loadstring(io.open("../data/playinfo.lua", "r"):read("*all"))()
loadstring(io.open("../data/news.lua", "r"):read("*all"))()

local function next_fltr(fltr, from)
    tab, col, val = fltr[1], fltr[2], fltr[3]
    for i = from+1,#tab do
        if tab[i][col] == val then return i, tab[i] end
    end
end

function pairs_fltr(tab, col, val)
    return next_fltr, {tab, col, val}, 1
end

local function nav()
    res=""
    for k,v in pairs(sections) do
        local section,title = v[1],v[2]
        locals.file = "/html/"..section..".html"
        locals.title = title
        locals.current = locals.name == section and "current" or ""
        res = res..engine:render_file("../elem/links.haml", locals) 
    end
    return res
end
locals.nav = nav

local function links()
    res=""
    for k,v in pairs_fltr(pages, 3, locals.section) do
        local name, title, section = v[1], v[2], v[3]
        locals.file = "/html/"..name..".html"
        locals.title = title        
        locals.current = locals.name == name and "current" or ""
        res = res..engine:render_file("../elem/links.haml", locals) 
    end
    return res
end
locals.links = links

local function css()
    local cssfile = "/css/"..locals.name..".less"
    local is = io.open("../"..cssfile,"r")
    return is and cssfile or "/css/index.less"
end
locals.css = css

local function content()
    local haml = "../cont/"..locals.name..".haml"
    if not io.open(haml, "r") then return "" end
    local res = engine:render_file(haml, locals) 
    return res
end
locals.content = content

local function elem( el_name )	
	local el_haml = "../elem/" .. el_name .. ".haml"
	local res = engine:render_file(el_haml, locals)    
	return res
end
locals.elem = elem

local function topnews()    
    local max=3
    local res = ""
    for i=1,max do
        locals.date, locals.newshead, locals.newsbody = news[i][1], news[i][2], news[i][3]
        res = res .. engine:render_file( "../elem/news.haml", locals)
    end
    return res
end
locals.topnews = topnews

local function getplaybill(max)
    max = max or 1
    local res = ""    
    for i=1,max do 
        locals.month,       locals.day,   locals.time       = playbill[i][1], playbill[i][2], playbill[i][3]
        locals.age,         locals.about, locals.playname   = playbill[i][4], playbill[i][5], playbill[i][6]
        locals.station,     locals.place, locals.addr       = playbill[i][7], playbill[i][8], playbill[i][9]
        res = res .. engine:render_file( "../elem/playbill.haml", locals)
    end
    return res
end
locals.playbill = getplaybill   

local function getplayinfo()    
    local res = ""    
    for i=1,#playinfo do 
        locals.playname, locals.short, locals.long       = playinfo[i][1], playinfo[i][2], playinfo[i][3]
        res = res .. engine:render_file( "../elem/playinfo.haml", locals)
    end
    return res
end
locals.playinfo = getplayinfo   

for k,v in pairs(pages) do
    local name, title, section = v[1], v[2], v[3]
    locals.section = section    
    locals.name = name
    local rendered = engine:render_file("../haml/template.haml", locals)
	html_name = name == "main" and "../index.html" or "../html/"..name..".html"
	io.open(html_name,"w+"):write(rendered);
	print(section.."/"..name .. "...done")
end

