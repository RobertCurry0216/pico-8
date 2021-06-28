pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function waterlevel_init(p)
	p=p or {[0]=128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143}
	pal(p,2)
	poke(0x5f5f,0x10)
end

function waterlevel(l)
	for y=0,15 do
		local mask=0
		for dy=7,0,-1 do
			mask <<= 1
			if y*8+dy >= l then
				mask |= 1
			end
		end
		memset(0x5f70+y,mask,1)
	end
end
