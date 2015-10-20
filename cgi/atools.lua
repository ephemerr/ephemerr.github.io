#!/usr/bin/lua

module("atools",package.seeall)

function ilements(tab, from)
    local from = from or 1
    if not tab[from] then return end
    return tab[from], ilements(tab,from+1)
end

function next_fltr(fltr, from)
    local from = from or 0
    tab, col, val = ilements(fltr)
    for i = from+1,#tab do
        if tab[i][col] == val then return i, tab[i] end
    end
    return nil
end

function pairs_fltr(tab, col, val)
    return next_fltr, {tab, col, val}, 0
end

return _M
