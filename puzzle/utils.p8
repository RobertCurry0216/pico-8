pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

--vectors utils
function new_vec(x,y)
	return {
		x=x,
		y=y,
	}
end

vec_add=function(self, other)	
	self.x += other.x
	self.y += other.y
end

vec_scaler=function(self, value)
	self.x *= value
	self.y *= value
end

--get the length of the vector
vec_length=function(self)
	return sqrt(self.x^2+self.y^2)
end

--get the normal of the vector
vec_norm=function(self)
	local l = self:vec_length()
	return new_vec(self.x / l, self.y / l);
end

vec_copy=function(self)
	return new_vec(self.x, self.y)
end

--square root.
function sqr(a) return a*a end

--round to the nearest whole number.
function round(a) return flr(a+0.5) end

function rectfill2(_x,_y,_w,_h,_c)
	rectfill(_x,_y,_x+_w-1,_y+_h-1,_c)
end

function rect2(_x,_y,_w,_h,_c)
	rect(_x,_y,_x+_w-1,_y+_h-1,_c)
end