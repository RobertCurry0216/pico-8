pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-------------------------------
--constants
-------------------------------
dirx={-1,1,0,0,1,1,-1,-1}
diry={0,0,-1,1,-1,1,1,-1}

-------------------------------
--text functions
-------------------------------
function oprint8(str,startx,starty,col,	col_bg)
	print(str,startx+1,starty,col_bg)
	print(str,startx-1,starty,col_bg)
	print(str,startx,starty+1,col_bg)
	print(str,startx,starty-1,col_bg)
	print(str,startx+1,starty-1,col_bg)
	print(str,startx-1,starty-1,col_bg)
	print(str,startx-1,starty+1,col_bg)
	print(str,startx+1,starty+1,col_bg)
	print(str,startx,starty,col)
end

-------------------------------
--math functions
-------------------------------
function clamp(lower, upper, value)
  if value < lower then return lower end
  if value > upper then return upper end
  return value
end

function bounce()
	return sin(time())>0.4 and 1 or 0
end

--round to the nearest whole number.
function round(a) return flr(a+0.5) end

function sqr(a) return a*a end

--make 2d vector
function m_vec(x,y)
	local v=
	{
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
	}
	return v
end

-------------------------------
--table functions
-------------------------------
function copy_table(arr)
	local _t={}
	for v in all(arr) do
		add(_t, v)
	end
	return _t
end

function get_rnd(arr)
	return arr[1+flr(rnd(#arr))]
end

function shuffle_table(arr)
	local ret, copy, v = {}, copy_table(arr)
	for i=1,#arr do
		v=getrnd(copy)
		add(ret, v)
		del(copy, v)
	end
	return ret
end

-------------------------------
--drawing functions
-------------------------------
function rectfill2(_x,_y,_w,_h,_c)
  rectfill(_x,_y,_x+_w-1,_y+_h-1,_c)
 end
 
 function rect2(_x,_y,_w,_h,_c)
  rect(_x,_y,_x+_w-1,_y+_h-1,_c)
 end