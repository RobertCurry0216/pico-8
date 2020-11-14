pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

particles = {}

function particles_drw()
  for p in all(particles) do
    if (costatus(p) ~= 'dead') then
      coresume(p)
    else
      del(particles, p)
    end
  end
end

function add_particle(x, y, a, s, r, l, c)
  local p = cocreate(function()
    for t=1,l do
      local dir = angle(0,0,s,a)
      circfill(x,y,r,c)
      x += dir.x
      y += dir.y
      s *= 0.94
      r *= 0.97
      yield()
    end
  end)
  add(particles, p)
end

function add_smoke(x, y)
  local r, c, l = rnd(2), light_gray, rnd(10) + 5
  local p = cocreate(function()
    for t=1,l do
      circfill(x,y,r,c)
      yield()
    end
  end)
  add(particles, p)
end