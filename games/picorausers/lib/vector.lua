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

function vector:__len()
  return sqrt(self.x*self.x + self.y*self.y)
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

function vector:limit(mag)
  if #self < abs(mag) then return end

  local v = self:norm() * mag
  self.x = v.x
  self.y = v.y
end

function vector:new(x, y)
  self.x = x or 0
  self.y = y or 0
end