submarine = enemy:extend()

function submarine:new(x)
  self.super.new(self, x, water_line)
  self.area = rect_area(0,0,48,8)
  self.area.offset = vector(0,8)
  self.health = 20
  self.score = 500
  self.difficulty = 6
  self.ram_damage = 1
  self.timer = timer.new()

  self.gun_pos_1 = self.pos + vector(5,5)
  self.gun_pos_2 = self.pos + vector(40,5)

  self.timer:during(32,
    function()
      self.pos.y -= 0.5
    end,
    function()
      self:fire_burst()
      self.timer:every(120, function() self:fire_burst() end)
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
  self.timer:every(6, function()
    add(enemy_bullets, missle(self.gun_pos_1, vector(0,-4), 100))
    add(enemy_bullets, missle(self.gun_pos_2, vector(0,-4), 100))
  end, 4)
end