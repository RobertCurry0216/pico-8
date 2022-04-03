rect_area = class:extend()

function rect_area:new(x, y, w, h, center)
  self.pos = vector(x,y)
  self.size = vector(w,h)
  if center then
    self.offset = self.size / -2
  else
    self.offset = vector()
  end
end

function rect_area:get_extents()
  local tl, br = self.pos+self.offset, self.pos+self.size+self.offset
  return tl.x, tl.y, br.x, br.y
end

function rect_area:contains_point(p)
  local x1, y1, x2, y2 = self:get_extents()
  return x1 < p.x and p.x < x2 and y1 < p.y and p.y < y2
end

function rect_area:contains(other)
  local x1, y1, x2, y2 = self:get_extents()
  local ox1, oy1, ox2, oy2 = other:get_extents()

  return x1 <= ox1
  and y1 <= oy1
  and x2 >= ox2
  and y2 >= oy2
end

function rect_area:overlaps(other)
  local x1, y1, x2, y2 = self:get_extents()
  local ox1, oy1, ox2, oy2 = other:get_extents()

  return x1 < ox2
  and ox1 < x2
  and y1 < oy2
  and oy1 < y2
end
