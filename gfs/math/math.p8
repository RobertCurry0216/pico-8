pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--constants
inf =  32767


--vectors
vector = {
  __tostring = function(self)
		return "<"..self.x..":"..self.y..":"..self.z..">"
  end,
  __add = function(self, other)
    local v = vector:new()
    v.x = self.x + other.x
    v.y = self.y + other.y
    v.z = self.z + other.z
    return v
  end,
  __sub = function(self, other)
    local v = vector:new()
    v.x = self.x - other.x
    v.y = self.y - other.y
    v.z = self.z - other.z
    return v
  end,
  __mul = function(self, other)
    local v = vector:new()
    v.x = self.x * other
    v.y = self.y * other
    v.z = self.z * other
    return v
  end,
  __div = function(self, other)
    local v = vector:new()
    v.x = self.x / other
    v.y = self.y / other
    v.z = self.z / other
    return v
<<<<<<< HEAD
  end,
  __len = function(self)
    return sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
=======
>>>>>>> ded3baeb49a4a4e00e6f15da8b9b1c588e6f865e
  end
}

function vector:new(x, y, z)
  --constructor
  local v = {}
  setmetatable(v, vector)
  v.x = x or 0
  v.y = y or 0
  v.z = z or 0

  --methods
<<<<<<< HEAD
  function v:copy()
    return vector:new(self.x, self.y, self.z)
  end

=======
>>>>>>> ded3baeb49a4a4e00e6f15da8b9b1c588e6f865e
  function v:dot(other)
	  return (self.x * other.x) + (self.y * other.y) + (self.z * other.z)
  end

  function v:cross(other)
    local v = vector:new()
    v.x = (self.y * other.z) - (self.z * other.y)
    v.y = (self.z * other.x) - (self.x * other.z)
    v.z = (self.x * other.y) - (self.y * other.x)
    return v
  end
<<<<<<< HEAD

  function v:norm()
    local v = self:copy()
    return v/#self
  end

=======
>>>>>>> ded3baeb49a4a4e00e6f15da8b9b1c588e6f865e
  return v
end