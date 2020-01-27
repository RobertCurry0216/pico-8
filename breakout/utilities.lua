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
function oprint8(_t,_x,_y,_c,_c2)
  for i=1,8 do
   print(_t,_x+dirx[i],_y+diry[i],_c2)
  end
  print(_t,_x,_y,_c)
 end

-------------------------------
--integer functions
-------------------------------
function clamp(lower, upper, value)
  if value < lower then return lower end
  if value > upper then return upper end
  return value
end

function bounce()
	return sin(time())>0.4 and 1 or 0
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