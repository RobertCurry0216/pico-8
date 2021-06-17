pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--dependencies
--[[
  math.p8
]]

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