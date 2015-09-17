#!/usr/bin/env wsapi.cgi
local wispers = require('ssrc.wispers')

function http_get(request_ptr, response_ptr)
  local request = wispers.fcgi_request(request_ptr)
  local param = wispers.parse_query_string(request:query_string())
  local x, y, sum, msg

  if param.x and param.y then
    x, y = tonumber(param.x), tonumber(param.y)
  end

  if x and y then
    sum = x + y
  end

  if sum then
    msg = x .. " + " .. y .. " = " .. sum
  else
    local response = wispers.fcgi_response(response_ptr)
    msg = "Error: invalid arguments."
    response:set_status(wispers.StatusBadRequest)
  end

  return string.format("<html><head><title>%s</title></head><body><h1>%s</h1></body></html>", msg, msg)
end
