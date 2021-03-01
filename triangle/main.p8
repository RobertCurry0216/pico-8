pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--main

function _init()
	vecs = {}
	for i=1,3 do
		v = vector:new(rnd(128), rnd(128))
		v.delta = vector:new(rnd(1), rnd(1))
		add(vecs, v)
	end

end

function _update60()
	for i=1,3 do
		local v = vecs[i]
		v = v + v.delta
		if v.x < 0 or v.x > 127 then
			vecs[i].delta.x *= -1
		end
		if v.y < 0 or v.y > 127 then
			vecs[i].delta.y *= -1
		end
		vecs[i].x = v.x
		vecs[i].y = v.y
	end
end

function _draw()
	cls()
	for v in all(vecs) do
		circ(v.x, v.y, 1, 15)
	end
end
-->8
--vectors

vector = {
	__tostring = function(self)
		return "<"..self.x..":"..self.y..":"..self.z..">"
	end,
	__add = function(self, other)
		local	v = vector:new()
		v.x = self.x + other.x
		v.y = self.y + other.y
		v.z = self.z + other.z
		return v
	end,
	__sub = function(self, other)
		local	v = vector:new()
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
	end
}

function __vector_dot(self,other)
	return (self.x * other.x) + (self.y * other.y) + (self.z * other.z)
end

function __vector_cross(self, other)
	local v = vector:new()
	v.x = (self.y * other.z) - (self.z * other.y)
	v.y = (self.z * other.x) - (self.x * other.z)
	v.z = (self.x * other.y) - (self.y * other.x)
	return v
end

function vector:new(x, y, z)
	local v = {}
	setmetatable(v, vector)
	v.x = x or 0
	v.y = y or 0
	v.z = z or 0
	v.dot = __vector_dot
	v.cross = __vector_cross
	return v
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
