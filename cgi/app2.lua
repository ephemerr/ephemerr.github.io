#!/usr/bin/env wsapi.fcgi
module(..., package.seeall)

local serpent = require "serpent"
local inspect = require "inspect"
local block = function(t) return  serpent.block(t, {comment=false}) end
local line = function(t) return  serpent.line(t, {comment=false}) end

function run(wsapi_env)
  local headers = { ["Content-type"] = "text/html" }

  local function hello_text()
    coroutine.yield("<html><body>")
    coroutine.yield("<p>Hello Wsapi!</p>")
    coroutine.yield("<p>PATH_INFO: " .. wsapi_env.PATH_INFO .. "</p>")
    coroutine.yield("<p>SCRIPT_NAME: " .. wsapi_env.SCRIPT_NAME .. "</p>")
    coroutine.yield("<p>QUERY_STRING: " .. wsapi_env.QUERY_STRING .. "</p>")
    coroutine.yield("<pre>" .. wsapi_env.REMOTE_ADDR ..  "</pre>")
    coroutine.yield("</body></html>")
  end

  return 200, headers, coroutine.wrap(hello_text)
end
