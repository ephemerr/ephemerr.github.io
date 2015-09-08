#!/usr/bin/lua

local haml         = require "haml"
local options      = {format = "html5"}
local engine       = haml.new(options)
local locals = {}

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

local names = { "index", "main",
                "theatre", "plays", "study", "contact",
                "hist", "rucov", "genre",
                "method", "reqruit",
                "allplays"
              }
for _, name in pairs(names) do 
	local rendered = engine:render_file( "../haml/"..name..".haml", locals)
	html_name = name == "main" and "../index.html" or "../html/"..name..".html"
	io.open(html_name,"w+"):write(rendered);
	print(name .. "...done")	
end