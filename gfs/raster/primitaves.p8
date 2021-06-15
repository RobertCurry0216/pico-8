pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--dependencies
--[[
  math.p8
]]

-->8
--lyne
lyne = {
  __tostring = function(self)
    return "<lyne:"..tostr(self.p1 ).."to"..tostr(self.p2)..">"
  end
}

function lyne:new(p1, p2, c)
  --constructor
  local l = {}
  setmetatable(l, lyne)
  l.p1 = p1 or vector:new()
  l.p2 = p2 or vector:new()
  l.color = c or 8
  --methods
  function l:render()
    drawlyne(self.p1.x,self.p1.y,self.p2.x,self.p2.y,self.color)
  end

  --end of class
  return l
end

function drawlyne(x1,y1,x2,y2,c)
  if abs(x2-x1) > abs(y2-y1) then
    if x1 > x2 then
      x1,x2 = x2,x1
      y1,y2 = y2,y1
    end
    local ys = interpol(x1,y1,x2,y2)
    for x=x1,x2 do
      pset(x,ys[flr(x-x1+1)],c)
    end
  else
    if y1 > y2 then
      x1,x2 = x2,x1
      y1,y2 = y2,y1
    end
    local xs = interpol(y1,x1,y2,x2)
    for y=y1,y2 do
      pset(xs[flr(y-y1+1)],y,c)
    end
  end
end