#!/usr/bin/lua

local haml         = require "haml"
local haml_options = {format = "html5"}
local engine       = haml.new(options)


local names = { "index", "theatre", "plays", "study", "contact" }

local locals = {}

for _, name in pairs(names) do 
	locals.css = "/css/"..name..".less"
	locals.content = io.open("../content/" .. name .. ".cont.html", "r"):read("*all")
	local rendered = engine:render_file("frame.haml", locals)	
	html_name = name == "index" and "../index.html" or "../html/"..name..".html"
	io.open(html_name,"w+"):write(rendered);
	print(name .. "...done")	
end