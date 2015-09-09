#!/usr/bin/lua

local haml         = require "haml"
local options      = {format = "html5"}
local engine       = haml.new(options)
local locals = {}

local tree = { 
                [1] = {         
                         [1] = {id = "index",    desc = "Пустая страница"}, 
                         [2] = {id = "main",     desc = "Главная"},
                    },
                [2] = {
                         [1] = {id = "theatre" , desc = "О театре"},
                         [2] = {id = "hist"    , desc = "История"}, 
                         [3] = {id = "rucov"   , desc = "Руководитель"}, 
                         [4] = {id = "genre"   , desc = "Наш жанр"}
                    },
                [3] = { 
                         [1] = {id = "plays"   , desc = "Афиша"}, 
                         [2] = {id = "allplays", desc = "Репертуар"} 
                    },
                [4] = { 
                         [1] = {id = "study"   , desc = "Студия"}, 
                         [2] = {id = "method"  , desc = "Методики"},
                         [3] = {id = "reqruit" , desc = "Набор"}
                    },
                [5] = {
                         [1] = {id = "contact" , desc = "Контакты"},
                    },
ppairs = function(tree, id)
   for i,sect in ipairs(tree) do    
        print(i)
        io.flush()
       if sect[1].id == id then break end
   end
   local function next(sect, i)
        return sect[i+1] and i+1, sect[i].id, sect[i].desc
   end
   return next, sect, 1
end 
}

-- local function nav()
--     res=""
--     for section,names in pairs(locals.tree) do
--         locals.file = "/html/"..section..".html"
--         locals.title = names[1]
--         locals.current = locals.name == section and "current" or "notcurrent"
--         res = res..engine:render_file("../elem/links.haml", locals) 
--     end
--     print (res)
--     return res
-- end
-- locals.nav = nav

local function links()
    res=""
    for n,val in pairs(tree:section(locals.section)) do
        name = val.id
        title = val.desc
        locals.file = "/html/"..name..".html"
        locals.title = title        
        locals.current = locals.name == name and "current" or "notcurrent"
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
    local newsstr = io.open("../data/news.lua", "r"):read("*all")
    loadstring(newsstr)()
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
    local playstr = io.open("../data/playbill.lua", "r"):read("*all")
    loadstring(playstr)()
    local res = ""
    for i=1,max do
        setmetatable(locals,{__index=playbill[i]})
        res = res .. engine:render_file( "../elem/playbill.haml", locals)
    end
    return res
end
locals.playbill = getplaybill   

for n,sect in ipairs(tree) do
    section = sect[1].id
    locals.section = section    
    for name,_ in pairs(sect) do
        locals.name = name
        local rendered = engine:render_file("../haml/template.haml", locals)
    	html_name = name == "main" and "../index.html" or "../html/"..name..".html"
    	io.open(html_name,"w+"):write(rendered);
    	print(section.."/"..name .. "...done")
    end
end

for k,v in tree:ppairs("theatre") do
    print (k,v)
end
