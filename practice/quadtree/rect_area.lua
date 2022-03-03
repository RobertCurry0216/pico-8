rect_area = class:extend()

function rect_area:__tostring()
  return "rect_area"
end

function rect_area:new(pos, size)
  self.pos = pos
  self.size = size
end

function rect_area:contains_point(p)
  local tl, br = self.pos, self.pos+self.size
  return tl.x < p.x and p.x < br.x and tl.y < p.y and p.y < br.y
end

function rect_area:contains(other)
  local tl, br = self.pos, self.pos+self.size
  local otl, obr = other.pos, other.pos+other.size
  return tl.x <= otl.x
  and tl.y <= otl.y
  and br.x >= obr.x
  and br.y >= obr.y
end

function rect_area:overlaps(other)
  local tl, br = self.pos, self.pos+self.size
  local otl, obr = other.pos, other.pos+other.size

  return tl.x < obr.x
  and otl.x < br.x
  and tl.y < obr.y
  and otl.y < br.y
end
