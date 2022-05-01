submarine = enemy:extend()

function submarine:new(x)
  self.super.new(self, x, water_line)
  self.area = rect_area(0,0,48,8)
  self.area.offset = vector(0,8)
  self.health = 20
  self.score = 500
  self.difficulty = 6
  self.ram_damage = 3
  self.timer = timer.new()

  self.gun_pos = self.pos + vector(24,0)

  self.timer:during(32,
    function()
      self.pos.y -= 0.5
    end,
    function()
      self:fire_burst()
      self.timer:every(90, function() self:fire_burst() end)
    end
  )
end

function submarine:update(plr)
  self.super.update(self, plr)
  self.timer:update()
end

function submarine:draw()
  spr(68, self.pos.x, self.pos.y, 6, 2)
end

function submarine:die()
  self.super.die(self)
  particles:spawn("submarine_sink", self.pos.x, self.pos.y)
  self.timer:clear()
end

function submarine:fire_burst()
  local target = plr.pos + plr.momentum*25
  local aim = self.gun_pos:to(target)
  add(enemy_bullets, big_bullet(self.gun_pos, aim, 500))
end