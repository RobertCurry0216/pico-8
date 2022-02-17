vector = {
  __tostring = function(self)
		return "<"..self.x..":"..self.y..">"
  end,
  __add = function(self, other)
    return vector:new(
    	self.x + other.x,
    	self.y + other.y
		)
  end,
  __sub = function(self, other)
    return vector:new(
    	self.x - other.x,
    	self.y - other.y
		)
  end,
  __mul = function(self, other)
    return vector:new(
    	self.x * other,
    	self.y * other
		)
  end,
  __div = function(self, other)
    return vector:new(
    	self.x / other,
    	self.y / other
		)
  end,
  __len = function(self)
    return sqrt(self.x*self.x + self.y*self.y)
  end
}

function vector:copy()
  return vector:new(self.x, self.y)
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

function vector:new(x, y)
  local v = {}
  setmetatable(v, vector)
  v.x = x or 0
  v.y = y or 0
  return v
end