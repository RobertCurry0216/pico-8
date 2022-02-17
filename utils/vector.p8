pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
--vectors
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

function vector:new(x, y)
  --constructor
  local v = {}
  setmetatable(v, vector)
  v.x = x or 0
  v.y = y or 0

  --methods
  function v:copy()
    return vector:new(self.x, self.y)
  end

  function v:dot(other)
	  return self.x*other.x + self.y*other.y
  end

  function v:cross(other)
    return self.x*other.y - self.y*other.x
  end

  function v:norm()
		local l = #self
  	if l==0 then 
  		return self:copy()
   end
   return self/l
  end

  return v
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
