vector = class:extend()

function vector:__tostring()
  return "<"..self.x..":"..self.y..">"
end

function vector:__add(other)
  return vector(
    self.x + other.x,
    self.y + other.y
  )
end

function vector:__sub(other)
  return vector(
    self.x - other.x,
    self.y - other.y
  )
end

function vector:__mul(other)
  return vector(
    self.x * other,
    self.y * other
  )
end

function vector:__div(other)
  return vector(
    self.x / other,
    self.y / other
  )
end

function vector:magsq()
  local _x = self.x
  local _y = self.y
  local m = _x*_x + _y*_y
  if m < 0 then
    return 0x7fff
  else
    return m
  end
end

function vector:mag()
  local v = self / 10
  return sqrt(v:magsq()) * 10
end

function vector:__len()
  return self:mag()
end

function vector:copy()
  return vector(self.x, self.y)
end

function vector:dot(other)
  return self.x*other.x + self.y*other.y
end

function vector:cross(other)
  return self.x*other.y - self.y*other.x
end

function vector:norm()
  local l = #self
  if l==0 then 
    return self:copy()
 end
 return self/l
end

function vector:rotate(theta)
  local x_tick = (self.x * cos(theta)) - (self.y * sin(-theta))
  local y_tick = (self.x * sin(-theta)) + (self.y * cos(theta))
  self.x = x_tick
  self.y = y_tick
end

function vector:angle()
  return atan2(self.x, self.y)
end

function vector:set_mag(mag)
  local v = self:norm() * mag
  self.x = v.x
  self.y = v.y
end

function vector:limit(mag)
  if #self < abs(mag) then return end
  self:set_mag(mag)
end

function vector:new(x, y)
  self.x = x or 0
  self.y = y or 0
end

function vector.from_polar(theta, mag)
  mag = mag or 1
  local v = vector(cos(theta), -sin(theta)) * mag
  return v
end


-- utils to allow wrapping
function vector:to(other)
  if abs(self.x - other.x) > width / 2 then
    if self.x - other.x < 0 then
      return other - (self + vector(width, 0))
    else
      return (other + vector(width, 0)) - self
    end
  end
  return other - self
end

function vector:wrap()
  if self.x < 0 then
    self.x += width
  elseif self.x > width then
    self.x -= width
  end
end