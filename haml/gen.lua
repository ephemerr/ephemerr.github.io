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
local names = { "index", "theatre", "plays", "study", "contact", "main" }
for _, name in pairs(names) do 
	local rendered = engine:render_file( "../haml/"..name..".haml", locals)
	html_name = name == "main" and "../index.html" or "../html/"..name..".html"
	io.open(html_name,"w+"):write(rendered);
	print(name .. "...done")	
end