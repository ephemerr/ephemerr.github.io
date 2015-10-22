module("utf8",package.seeall)
require'libluautf8'

local mt = {}
local unistr = {}
function unistr:new(str)
	return setmetatable({value = str or ''},mt)
end

-- redirects methods to unistr
mt.__index = function(t,key) 
	if key == 'length' then return string.utf8len(t.value) end
	if key == 'value' then return t.value end
	return unistr[key]
end

-- substrings, utf8 ready
-- it might be very expensive
-- isn't every encoding function expensive compared to raw access
-- to bytes
function unistr:sub (first, last)
	local fn 
	fn = function (str,idx)
		if idx == 1 or idx == 0 then return idx end
		if idx<0 then
			-- negative indices are counted backwards
			return str:seekutf8(#str, idx) or 1
		else
			return str:seekutf8(1, idx-1) or #str+1
		end
	end
	local i = fn(self.value, first)
	if last == nil then
		return self.value:sub(i)
	end
	if last < 0 then
		if first > 0 or (first<0 and last-first > -last) then
			-- we must anyway walk through the encoded string
			-- when walking from the end of the string backwards
			-- has costs less than walking from the first index
			-- we choose the least cost
			
			-- we get the last index from fn
			return self.value:sub(i, fn(self.value, last))
		end
	end
	if first == 0 then return self.value:sub(i, fn(self.value, last)) end
	return self.value:sub(i, self.value:seekutf8(i, last-first))	
end
u2s=function (str)
	if type(str) == 'string' then return str else return str.value end
end
	
-- unicode strings concat
function mt.__concat(a,b) 
	return u(u2s(a)..u2s(b)) 
end
-- encoded string length with a metatable is not possible
-- so let's stick with a len() method
function unistr:len() 
	return self.value:utf8len() 
end
-- iterator
function unistr:each(pos) return string.nextutf8, self.value, pos or 1 end
-- creates a global "u" function to be used like that: 
-- str = u"Hello" (it feels Python-like but is really a Lua function)
-- then, thanks to the metatable mechanism, concatenation and other funcs
-- can be invoked as if it was a simple scalar of type string
u = function(str) return unistr:new(str) end

function unicodize(f)
	return function(str) return f(u2s(str)) end
end
_G.print = unicodize(print)
-- return this function
return _M 
