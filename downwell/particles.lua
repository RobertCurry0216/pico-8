pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

particles = {}
-------------------------------
--particle event functions
-------------------------------
function part_jump_smoke(pos)
  for x=1, 2 + ceil(rnd(3)) do
    new_basic_particle(pos)
  end
end

function part_shoot_smoke(pos)
  p = new_basic_particle(pos)
  p.pos.y += 5
  p.dir = m_vec(0,0)
  p.radius = 3
end

-------------------------------
--particle types
-------------------------------
function new_basic_particle(pos)
  local p = {
    pos=pos:copy"",
    dir = m_vec(rnd(4) - 2, rnd(1)),
    life = 3 + rnd(5),
    radius=rnd(2) + 1,

    update=function(self)
      self.life -= 1
      if (self.life < 0) del(particles, self)
      self.pos:add(self.dir)
    end,

    draw=function(self)
      circfill(self.pos.x, self.pos.y, self.radius, 6)
    end,
  }
  add(particles, p)
  return p
end

function upd_particles()
  for p in all(particles) do 
    p:update""
  end
end

function drw_particles()
  for p in all(particles) do 
    p:draw""
  end
end 