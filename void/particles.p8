pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function particles_drw()
  for p in all(particles) do
    if (costatus(p) ~= 'dead') then
      coresume(p)
    else
      del(particles, p)
    end
  end
end

function bh_particles_drw()
  for p in all(bh_particles) do
    if (costatus(p) ~= 'dead') then
      coresume(p)
    else
      del(bh_particles, p)
    end
  end
end

function add_bh_particle(a, s, r, l)
  local d = angle(64, 64, bh_size - 4, a)
  local x, y = d.x, d.y
  add(bh_particles, cocreate(function()
    for t=1,l do
      local dir = angle(0,0,s,a)
      circfill(x,y,r+1,dark_blue)
      yield()
      circfill(x,y,r,c)
      x += dir.x
      y += dir.y
      s *= 0.94
      r *= min(0.97, (l-t) / 4)
      yield()
    end
  end))
end

function add_smoke(x, y)
  local r, c, l = rnd(2), light_gray, rnd(10) + 5
  add(particles, cocreate(function()
    for t=1,l do
      circfill(x,y,r,c)
      yield()
    end
  end))
end

function add_float(x, y, text, c)
  x -= (#text / 2)*4
  add(particles, cocreate(function()
    for i=1,30 do
      print(text,x,y + (cos(i/60)*5),c)
      yield()
    end
  end))
end