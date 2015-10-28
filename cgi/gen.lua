#!/usr/bin/lua

local inspect = require "inspect"

module("gen",package.seeall)

local luahaml         = require "haml"
local options      = {format = "html5"}
local engine       = luahaml.new(options)

local tools        = require "atools"
local next_fltr    = tools.next_fltr
local pairs_fltr   = tools.pairs_fltr

local locals = {}

local drive = require"luasql.mysql"
local env = assert (drive.mysql())
local mysql = assert (env:connect("theater","root","123456","localhost",3306 ))
mysql:execute("SET @@lc_time_names='ru_RU';")

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

locals.sqlview = function(name,hamlname)
    local hamlname = hamlname or name
    local res={}
    local cursor = assert(mysql:execute("SELECT * FROM "..name..";"))
    while cursor:fetch(locals, "a") do
        table.insert(res, haml(hamlname))
    end
    return table.concat(res)
end

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
