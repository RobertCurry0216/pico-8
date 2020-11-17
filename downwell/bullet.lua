pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

bullets = {}
bullet_fire_rate = 0
ammo_clip_size = 8
ammo = ammo_clip_size

-- machine gun
function new_machinegun()
  return {
    ammo = 8,
    max_ammo = 8,

    shoot=function(self, pos)
      
      --check ammo
      -- if ammo empty
      if self.ammo < 1 then
        part_jump_smoke(pos)
        bullet_fire_rate = 6
        player.jump_btn_released = false --don't love this
        return -0.1
      end
      --shoot
      new_basic_bullet(pos)
      part_shoot_smoke(pos)
      bullet_fire_rate = 2
      self.ammo -= 1
      return -0.6
    end,

    reload=function(self)
      self.ammo = self.max_ammo
    end,
  }
end


-- default bullet type
function new_basic_bullet(pos, dx, dy)

  -- default parameters
  dx = dx or 0
  dy = dy or 3

  -- add bullet to global bullet list
  add(bullets, {
    pos=pos:copy"",
    dir=m_vec(dx, dy),
    life=15,

    -- update position and collision detection
    update=basic_bullet_move,

    -- draw to screen
    draw=function(self)
      rectfill2(self.pos.x-1,self.pos.y, 2, 5, cmain)
    end
  })
end

function basic_bullet_move(self)
  self.life -= 1
  if (self.life < 0) del(bullets, self)
  self.pos:add(self.dir)
end

function upd_bullets()
  bullet_fire_rate -= 1
  for b in all(bullets) do 
    b:update""
  end
end

function drw_bullets()
  for b in all(bullets) do 
    b:draw""
  end
end