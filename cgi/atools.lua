#!/usr/bin/lua

module("atools",package.seeall)

--- Search in table

function next_fltr(fltr, from)
    local from = from or 0
    tab, col, val = unpack(fltr)
    for i = from+1,#tab do
        if tab[i][col] == val then return i, tab[i] end
    end
    return nil
end

function pairs_fltr(tab, col, val)
    return next_fltr, {tab, col, val}, 0
end

--- Calend tools
--
month = {
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
    January   = 'Январь',
    February  = 'Февраль',
    March     = 'Март',
    April     = 'Апрель',
    May       = 'Май',
    June      = 'Июнь',
    July      = 'Июль',
    August    = 'Август',
    September = 'Сентябрь',
    October   = 'Октябрь',
    November  = 'Ноябрь',
    December  = 'Декабрь',
}

wday = {
    Sun = 'Вс',
    Mon = 'Пн',
    Tue = 'Вт',
    Wed = 'Ср',
    Thu = 'Чт',
    Fri = 'Пт',
    Sat = 'Сб'
}

local function mnum(mname)
    for i = 1,#month do
        if month[i] == mname then return i end
    end
end

function date_parts(date_str)
  _,_,y,m,d=string.find(date_str, "(%d+)-(%d+)-(%d+)")
  return tonumber(y),tonumber(m),tonumber(d)
end

function day_of_week(dd, mm, yy) 
  assert(dd*mm*yy ~= 0)
  --local days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }
  local days = { "Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб" }

  local mmx = mm

  if (mm == 1) then  mmx = 13; yy = yy-1  end
  if (mm == 2) then  mmx = 14; yy = yy-1  end

  local val8 = dd + (mmx*2) +  math.floor(((mmx+1)*3)/5)   + yy + math.floor(yy/4)  - math.floor(yy/100)  + math.floor(yy/400) + 2
  local val9 = math.floor(val8/7)
  local dw = val8-(val9*7) 

  if (dw == 0) then
    dw = 7
  end

  return dw, days[dw]
end


return _M
