pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

--make 2d vector
function m_vec(x,y)
	return {
		x=x,
		y=y,
		
  --get the length of the vector
		get_length=function(self)
			return sqrt(self.x^2+self.y^2)
		end,
		
  --get the normal of the vector
		get_norm=function(self)
			local l = self:get_length()
			return m_vec(self.x / l, self.y / l),l;
    end,
    
    copy=function(self)
      return m_vec(self.x, self.y)
    end
	}
end

--square root.
function sqr(a) return a*a end

--round to the nearest whole number.
function round(a) return flr(a+0.5) end