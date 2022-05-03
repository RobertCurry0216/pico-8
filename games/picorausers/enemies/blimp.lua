blimp = enemy:extend()

function blimp:new(x)
  self.super.new(self, x, -16)
  self.area = rect_area(0,0,24,8)
  self.health = 10
  self.score = 750
  self.difficulty = 8
  self.ram_damage = 4
  self.max_speed = 0.1
  self.timer = timer.new()

  self.gun_offset = vector(12,-8)
  self.gun_pos = self.pos + self.gun_offset

  self.timer:during(32,
    function()
      self.pos.y += 0.5
    end,
    function()
      self.timer:every(120, function() self:fire_burst() end)
    end
  )
end

function blimp:steering()
  return seek(plr, self)
end

function blimp:update(plr)
  self.super.update(self, plr)
  self.timer:update()
  if self.pos.y > 256 then self.pos.y = 256 end
  self.gun_pos = self.pos + self.gun_offset
end

function blimp:draw()
  spr(74, self.pos.x, self.pos.y, 3, 2)
end

function blimp:die()
  self.super.die(self)
  sfx(6)
  particles:spawn("blimp_die", self.pos.x, self.pos.y)
  self.timer:clear()
end

function blimp:fire_burst()
  self.timer:every(5, function()
    add(enemy_bullets, missle(self.gun_pos, vector(0,1), 200))
  end, 4)
end