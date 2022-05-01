boat = enemy:extend()

function boat:new(x)
  self.super.new(self, x, water_line)
  self.area = rect_area(0,0,32,8)
  self.area.offset = vector(0,8)
  self.health = 8
  self.score = 250
  self.difficulty = 4
  self.ram_damage = 1
  self.timer = timer.new()

  self.aim = vector()
  self.gun_pos = self.pos + vector(5,-11)
  self.state = "raise"

  self.timer:during(32,
    function()
      self.pos.y -= 0.5
    end,
    function()
      self.state = "aim"
      self.timer:every(90, function() self:fire_burst() end)
    end
  )
end

function boat:update(plr)
  self.super.update(self, plr)
  self.timer:update()

  if self.state == "aim" then
    self.aim = plr.pos + plr.momentum*25 - self.gun_pos
    self.aim:set_mag(2)
  end
end

function boat:draw()
  spr(64, self.pos.x, self.pos.y, 4, 2)
  if self.state != "raise" then
    vline(self.gun_pos, self.gun_pos+self.aim, 2)
  end
end

function boat:die()
  self.super.die(self)
  sfx(6)
  particles:spawn("boat_sink", self.pos.x, self.pos.y)
  self.timer:clear()
end

function boat:fire_burst()
  self.state = "fire"
  self.timer:every(5, function()
    add(enemy_bullets, enemy_bullet(self.gun_pos, self.aim, 200))
  end, 5)
  self.timer:after(30, function() self.state = "aim" end)
end