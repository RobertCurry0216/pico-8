pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--utils
--dependencies
--[[
  math.p8
]]

--trifill
function trifill(x1,y1,x2,y2,x3,y3,c)
  if y2 < y1 then x1,y1, x2,y2 = x2,y2, x1,y1 end
  if y3 < y1 then x1,y1, x3,y3 = x3,y3, x1,y1 end
  if y3 < y2 then x3,y3, x2,y2 = x2,y2, x3,y3 end
  color(c)

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

  color()
end

-->8
--camera
camera = {
  __tostring = function(self)
    return "<camera>"
  end
}

function camera:new()
  --constructor
  local c = {}
  setmetatable(c, camera)
  c.pos = vector:new()
  c.vwidth = 8
  c.vheight = 8
  c.vdepth = 1
  c.voffset = vector:new(64,64)

  --methods
  function c:projectvertex(v)
    local x,y = v.x*self.vdepth/v.z, v.y*self.vdepth/v.z
    x *= (128/self.vwidth)
    y *= (128/self.vheight)
    return vector:new(x,y) + self.voffset
  end

  function c:renderline(p1,p2,col)
    local c1 = self:projectvertex(p1)
    local c2 = self:projectvertex(p2)
    line(c1.x,c1.y,c2.x,c2.y,col)
  end

  function c:render()
    local vAf = vector:new(-1,  1, 1)
    local vBf = vector:new( 1,  1, 1)
    local vCf = vector:new( 1, -1, 1)
    local vDf = vector:new(-1, -1, 1)

    local vAb = vector:new(-1,  1, 2)
    local vBb = vector:new( 1,  1, 2)
    local vCb = vector:new( 1, -1, 2)
    local vDb = vector:new(-1, -1, 2)

    self:renderline(vAf, vBf, 12);
    self:renderline(vBf, vCf, 12);
    self:renderline(vCf, vDf, 12);
    self:renderline(vDf, vAf, 12);

    self:renderline(vAb, vBb, 8);
    self:renderline(vBb, vCb, 8);
    self:renderline(vCb, vDb, 8);
    self:renderline(vDb, vAb, 8);

    self:renderline(vAf, vAb, 3);
    self:renderline(vBf, vBb, 3);
    self:renderline(vCf, vCb, 3);
    self:renderline(vDf, vDb, 3);
  end

  --end class
  return c
end