pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-------------------------------
--math
-------------------------------
--square root.
function sqr(a) return a*a end

--round to the nearest whole number.
function round(a) return flr(a+0.5) end


-------------------------------
--drawing
-------------------------------
function rectfill2(_x,_y,_w,_h,_c)
  rectfill(_x,_y,_x+_w-1,_y+_h-1,_c)
 end
 
 function rect2(_x,_y,_w,_h,_c)
  rect(_x,_y,_x+_w-1,_y+_h-1,_c)
 end

-------------------------------
--tables
-------------------------------
function join(t1, t2)
	for v in all(t2) do
		add(t1, v)
	end
end