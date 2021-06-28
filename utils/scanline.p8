pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function scanline()
	local p={[0]=128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143}
	pal(p,2)
	poke(0x5f5f,0x10)
	memset(0x5f70,0b10101010,16)
end
