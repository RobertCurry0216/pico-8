pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function bh_upd()
  for _=1,4 do
    local ang = rnd(360)
    local dir = angle(64, 64, 8, ang)
    --          x   y   ang       spd       radius     life      col
    add_particle(dir.x, dir.y, ang, rnd(1), rnd(4)+1, rnd(10)+15, black)
  end
end

function bh_drw()
  circfill(64,64,12,black)
end