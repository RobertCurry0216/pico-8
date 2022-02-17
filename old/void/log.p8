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
--debug functions
-------------------------------

log = {}

function draw_log()
	local _x, _y = 2, 2
	for k, txt in pairs(log) do
		oprint8(k..":"..tostr(txt), _x, _y, 8, 0)
		_y += 6
	end
end

function log_stats()
	log.fr = stat(7)
  log.mem = stat(0)
  log.cpu = stat(1)
end