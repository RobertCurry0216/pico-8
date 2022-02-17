pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--dependencies
--[[
  math.p8
]]

--primative shapes

--sphere
sphere = {
  __tostring = function(self)
    return "<sphere:r:"..self.radius..":"..tostr(self.pos)..">"
  end
}

function sphere:new(x,y,z,r,c)
  --constructor
  local s = {}
  setmetatable(s, sphere)
  s.type = "sphere"
  s.radius = r or 1
  s.color = c or 8
  s.pos = vector:new(x,y,z)

  --methods
  function s:intersects(o,d)
    return intersect_fns[self.type](o,d,self)
  end

  return s
end

--intersects functions
intersect_fns = {
  sphere = function(origin, dir, actor)
    local oc, k1, k2, k3, dis, t1, t2
    oc = origin - actor.pos
    k1 = dir:dot(dir)
    k2 = 2*oc:dot(dir)
    k3 = oc:dot(oc)-(actor.radius*actor.radius)
    dis = (k2*k2) - (4*k1*k3)

    if dis < 0 then
      return {inf, inf}
    end
    t1 = (-k2 + sqrt(dis)) / (2*k1)
    t2 = (-k2 - sqrt(dis)) / (2*k1)

    return {t1, t2}
  end
}