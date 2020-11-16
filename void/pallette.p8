pico-8 cartridge // http://www.pico-8.com
version 18
__lua__


function set_pallette(p)
  cls()
  spr(num,0,0)
  for y=1,6 do
    pal(pget(0,y-1), pget(p-1,y-1))
  end
  cls()
end