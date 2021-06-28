pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--palswap
function palswap(p)
	p=p or {[0]=128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143}
	pal(p,1)
end
