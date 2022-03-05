polygon = class:extend()

function polygon:new(pos, sides, radius)
  self.pos = pos
  self.heading = -0.25
  self.points = {}
  for i=0,sides do
    add(self.points, vector.from_polar(i/sides, radius))
  end
end

function polygon:update()
  self.heading += inputs.dx * 0.01
  if inputs.up then
    self.pos += vector.from_polar(self.heading, 2)
  end
end

function polygon:draw()
  local transformed = self:transformed()
  line(self.pos.x, self.pos.y, transformed[1].x, transformed[1].y)

  for p in all(transformed) do
    line(p.x, p.y)
  end
end

function polygon:transformed()
  local t = {}
  for p in all(self.points) do
    add(t, p:copy():rotate(self.heading) + self.pos)
  end
  return t
end

function polygon:overlaps(other)
  local tp1 = self:transformed()
  local tp2 = other:transformed()

  return polygon._overlaps_dat(tp1, self.pos, tp2) or polygon._overlaps_dat(tp2, other.pos, tp1)
end

function polygon._overlaps_sat(tp1, tp2)
  for i=2,#tp1 do
    local a, b = tp1[i-1], tp1[i]
    local proj_axis = vector(-b.y - a.y, b.x - a.x):norm()

    --min + max projection points for self
    local min_p1, max_p1 = 32767, -32768 
    for p in all(tp1) do
      local q = p:dot(proj_axis)
      min_p1 = min(min_p1, q)
      max_p1 = max(max_p1, q)
    end

    --min + max projection points for other
    local min_p2, max_p2 = 32767, -32768
    for p in all(tp2) do
      local q = p:dot(proj_axis)
      min_p2 = min(min_p2, q)
      max_p2 = max(max_p2, q)
    end

    if not (max_p2 > min_p1 and max_p1 > min_p2) then
      return false
    end
  end

  return true
end

function polygon._overlaps_dat(tp1, cp1, tp2)
  for i = 2,#tp1 do
    local ds1 = tp1[i]

    for j = 2,#tp2 do
      local es2, ee2 = tp2[j-1], tp2[j]

      local h = (ee2.x - es2.x) * (ds1.y - cp1.y) - (ds1.x - cp1.x) * (ee2.y - es2.y)
			local t1 = ((es2.y - ee2.y) * (ds1.x - es2.x) + (ee2.x - es2.x) * (ds1.y - es2.y)) / h
      local t2 = ((ds1.y - cp1.y) * (ds1.x - es2.x) + (cp1.x - ds1.x) * (ds1.y - es2.y)) / h

      if t1 >= 0 and t1 < 1 and t2 >= 0 and t2 < 1 then
        return true
      end
    end
  end
  return false
end