pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--constants
inf =  32767

darkenshademap = {
		"0,0,0,0,0,0",
		"1,1,1,0,0,0",
		"2,2,1,1,0,0",
		"3,3,3,1,1,0",
		"4,2,2,1,1,0",
		"5,5,1,1,1,0",
		"6,6,13,5,1,0",
		"7,7,6,13,1,0",
		"8,8,2,2,1,0",
		"9,4,2,2,1,0",
		"10,9,4,2,1,0",
		"11,11,3,3,1,0",
		"12,12,13,5,1,0",
		"13,13,5,1,1,0",
		"14,14,4,2,1,0",
		"15,9,4,2,1,0",
	}

--utils
function round(v)
  return flr(v+0.5)
end

function darken(c,v)
	return tonum(split(darkenshademap[c+1])[v])
end

function join(a,b)
  local t = {}
  for v in all(a) do
    add(t,v)
  end
  for v in all(b) do
    add(t,v)
  end
  return t
end

-->8
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
  end,
  __len = function(self)
    return sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
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
  function v:copy()
    return vector:new(self.x, self.y, self.z)
  end

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

  function v:norm()
    local v = self:copy()
    return v/#self
  end

  return v
end

--vector helpers
function v_update(self,other)
  self.x += other.x
  self.y += other.y
  self.z += other.z
end
