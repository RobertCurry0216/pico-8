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

-->8
--triangles

triangle = {
  __tostring = function(self)
    return "<tri:".."col="..tostr(self.color)..">"
  end
}

function triangle:new(p1, p2, p3, c)
  --constructor
  local t = {}
  setmetatable(t, triangle)
  t.p1 = p1 or vector:new()
  t.p2 = p2 or vector:new()
  t.p3 = p3 or vector:new()
  t.color = c or 8
  t.filled = true

  --methods
  function t:render()
    local p1,p2,p3 = self.p1,self.p2,self.p3
    if p2.y < p1.y then p1, p2 = p2, p1 end
    if p3.y < p1.y then p1, p3 = p3, p1 end
    if p3.y < p2.y then p3, p2 = p2, p3 end
    color(c)
    if self.filled then
      drawtrifilled(
        p1.x,
        p1.y,
        p2.x,
        p2.y,
        p3.x,
        p3.y,
        self.color
      )
    else
      drawtri(
        p1.x,
        p1.y,
        p2.x,
        p2.y,
        p3.x,
        p3.y,
        self.color
      )
    end
    color()
  end
  --end class
  return t
end

function drawtri(x1,y1,x2,y2,x3,y3,c)
  line(x1,y1,x2,y2)
  line(x3,y3)
  line(x1,y1)
end

function drawtrifilled(x1,y1,x2,y2,x3,y3,c)
  -- find x values
  local x12 = interpol(y1,x1,y2,x2)
  local x23 = interpol(y2,x2,y3,x3)
  local x13 = interpol(y1,x1,y3,x3)
  deli(x12)
  local x123 = join(x12,x23)
  
  -- determine left/right
  local m = ceil(#x123/2)
  local xleft, xright
  if x13[m] < x123[m] then
    xleft = x13
    xright = x123
  else
    xleft = x123
    xright = x13
  end

  --draw lines
  local ymax = ceil(y3-y1)
  for y=1,ymax do
    line(xleft[y],y+y1,xright[y],y+y1,c)
  end
  -- pixel by pixel method
  -- for y=y1,y3 do
  --   for x=xleft[y-y1+1],xright[y-y1+1] do
  --     pset(x,y,c)
  --   end
  -- end
end