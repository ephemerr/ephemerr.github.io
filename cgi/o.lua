#!/usr/bin/env wsapi.cgi

local orbit = require "orbit"
local gen = require "gen"
local serpent = require "serpent"
local block = serpent.block
local line = function(t) return  serpent.line(t, {comment=false}) end

module("o", package.seeall, orbit.new)


---- CONTROLERS

function index(web, name)
    web:set_cookie("user", "master") 
    return "index"
end

function page(web, name)
    if name == "cookie" then 
        return [[
        Content-type: text/html
        Set-Cookie: "username=aaa13; expires=Friday, 31-Dec-99 23:59:59 GMT; path=/; domain=my.dom;"
        ]]
        end
    local inner_html = block(web.GET) .. block(web.input) 
    return render_layout(inner_html)
end

function posthome(web, name)
    local inner_html = line(web.POST) 
                        .. block(web.vars)
    local answer = io.open("../data/answer.lua","a+")
    if answer then 
        entry = {web.POST.name, web.POST.text}
       answer:write(line(entry) .. ",\n")
    end
    return render_layout(inner_html)
end

---- DISPATCH

o:dispatch_get(index, "/")
o:dispatch_get(page, "/(%a+)")
o:dispatch_post(posthome, "/")
o:dispatch_post(post, "/(%a+)")
 
----- 

function show_info(web, add) 
    return 
     "app.real_path: " .. o.real_path .. 
     "- - -" ..
     "web.real_path: " .. web.real_path ..
     "- - -" ..
     "web.path_info: " .. web.path_info .. " _____" .. (add or "" )
end


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
