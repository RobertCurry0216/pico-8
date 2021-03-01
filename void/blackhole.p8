pico-8 cartridge // http://www.pico-8.com
version 18
__lua__



function bh_upd()
  for _=1,ceil(bh_size/6) do
    local ang = rnd(360)
    --               ang    spd    radius   life 
    add_bh_particle(ang, rnd(1), rnd(4)+1, rnd(10)+15)
  end
end

function bh_drw(drw_circ)
  if (drw_circ == nil) circ(64,64,escape_radius,dark_blue)

  bh_particles_drw()
  circfill(64,64,bh_size+1,dark_blue)

  bh_particles_drw()
  circfill(64,64,bh_size,black)
end