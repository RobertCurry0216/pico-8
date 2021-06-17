pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--utils
--dependencies
--[[
  math.p8
]]

--trifill
function trifill(p1, p2, p3, c)
  local x1,y1 = p1.x, p1.y
  local x2,y2 = p2.x, p2.y
  local x3,y3 = p3.x, p3.y
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

  --draw lines
  local ymax = ceil(y3-y1)
  for y=1,ymax do
    line(x13[y],y+y1,x123[y],y+y1,c)
  end

  color()
end

function triwire(p1,p2,p3,c)
  color(c)
  line(p1.x,p1.y,p2.x,p2.y)
  line(p3.x,p3.y)
  line(p1.x,p1.y)
  color()
end

-->8
--objects

triangle = {
  __tostring = function(self) return "<tri:"..self.p1..":"..self.p2..":"..self.p3..">" end
}

function triangle:new(p1,p2,p3,col)
  --constructor
  local t = {}
  setmetatable(t, triangle)
  t.p1 = p1
  t.p2 = p2
  t.p3 = p3
  t.col = col
  --methods

  --end class
  return t
end

model = {
  __tostring = function(self) return "<model:"..self.name..">" end
}

function model:new(points, triangles, name)
  --constructor
  local m = {}
  setmetatable(m, model)
  m.name = name or "-"
  m.points = points
  m.triangles = triangles
  --methods

  --end class
  return m
end

instance = {
  __tostring = function(self) return "<inst:"..self.model.name..">" end
}

function instance:new(model, pos)
  --constructor
  local i = {}
  setmetatable(i, instance)
  i.model = model
  i.pos = pos or vector:new()
  --methods

  --end class
  return i
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
  c.vwidth = 1
  c.vheight = 1
  c.vdepth = 1
  c.voffset = vector:new(64,64)

  --methods
  function c:projectvertex(v)
    local x,y = v.x*self.vdepth/v.z, v.y*self.vdepth/v.z
    x *= (128/self.vwidth)
    y *= (128/self.vheight)
    return vector:new(x,y) + self.voffset
  end

  function c:renderinst(inst)
    --project all points into scene
    local proj = {}
    for p in all(inst.model.points) do
      add(proj, self:projectvertex(p + inst.pos))
    end

    --draw projected triangles
    for t in all(inst.model.triangles) do
      local p1 = proj[t.p1]
      local p2 = proj[t.p2]
      local p3 = proj[t.p3]
      trifill(p1, p2, p3, t.col)
    end
  end

  function c:render(scene)
    for i in all(scene) do
      self:renderinst(i)
    end
  end

  --end class
  return c
end