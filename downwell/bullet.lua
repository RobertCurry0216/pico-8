pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

bullets = {}
bullet_rate = 0

-- machine gun
-- default bullet type
function new_bullet(pos, dx, dy)
  -- default parameters
  dx = dx or 0
  dy = dy or 3

  -- add bullet to global bullet list
  add(bullets, {
    pos=pos:copy"",
    dir=m_vec(dx, dy),
    life=15,

    -- update position and collision detection
    update=function(self)
      self.life -= 1
      if (self.life < 0) del(bullets, self)
      self.pos.x += self.dir.x
      self.pos.y += self.dir.y
    end,

    -- draw to screen
    draw=function(self)
      rectfill(self.pos.x-1,self.pos.y, self.pos.x+1,self.pos.y+5,7)
    end
  })

  -- fire rate
  if (bullet_rate < 1) return false
  bullet_rate = 7
  --return player new 
  return -0.6
end

function upd_bullets()
  bullet_rate -= 1
  for b in all(bullets) do 
    b:update()
  end
end

function drw_bullets()
  for b in all(bullets) do 
    b:draw()
  end
end