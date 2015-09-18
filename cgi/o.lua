#!/usr/bin/env wsapi.cgi

local orbit = require "orbit"
local gen = require "gen"
local ins = require "inspect"

module("o", package.seeall, orbit.new)

function index(web, name)
  return show_info(web)
  --return   --return gen.genpage"main"
end

function page(web, name)
  return show_info(web)
  --return gen.genpage(name)
end

function post(web, name)
    local inner_html = ins(web.POST) 
    return render_layout(inner_html)
end

function show_info(web, add) 
    return 
     "app.real_path: " .. o.real_path .. 
     "- - -" ..
     "web.real_path: " .. web.real_path ..
     "- - -" ..
     "web.path_info: " .. web.path_info .. " _____" .. add 
end


o:dispatch_get(index, "/")
o:dispatch_get(page, "/(%a+)")
o:dispatch_post(post, "/")
 

function render_layout(inner_html)
   return html{
     head{ title"Hello" },
     body{ 
         pre{inner_html}
     }
   }
end

orbit.htmlify(o, "render_.+")

return _M
