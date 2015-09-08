#!/usr/bin/lua

local haml         = require "haml"
local options      = {format = "html5"}
local engine       = haml.new(options)
local locals = {}

locals.tree = { ["root"]    = { ["index"] = "Пустая страница", 
                                ["main"] = "Главная",
                            },
                ["theatre"] = {
                                ["theatre"] = "О театре", 
                                ["hist"]    = "История", 
                                ["rucov"]   = "Руководитель", 
                                ["genre"]   = "Наш жанр"
                            },
                ["plays"]   = { 
                                ["plays"]   = "Афиша", 
                                ["allplays"]= "Репертуар" 
                            },
                ["study"]   = { 
                                ["study"]   = "Студия", 
                                ["method"]  = "Методики",
                                ["reqruit"] = "Набор"
                            },
                ["contact"] = { ["contact"] = "Контакты"},
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
    for name,title in pairs(locals.tree[locals.section]) do
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

for section,names in pairs(locals.tree) do
    locals.section = section    
    for name,_ in pairs(names) do
        locals.name = name
        local rendered = engine:render_file("../haml/template.haml", locals)
    	html_name = name == "main" and "../index.html" or "../html/"..name..".html"
    	io.open(html_name,"w+"):write(rendered);
    	print(section.."/"..name .. "...done")
    end
end