shooter = enemy:extend()

function shooter:new(x)
  self.super.new(self, x, -16)
  self.area = rect_area(0,0,8,8)
  self.health = 10
  self.score = 500
  self.difficulty = 5
  self.ram_damage = 2
  self.max_speed = 5
  self.timer = timer.new()
  self.timer:every(60, function() self:fire_burst() end)
end

function shooter:steering()
  return follow(plr, self, 20)
end

function shooter:update(plr)
  self.super.update(self, plr)
  self.timer:update()
  if self.pos.y > height then self.pos.y = height end
end

function shooter:draw()
  self.super.draw(self)

  local pos = self.pos
  local angle = -self.vel:angle()
  local tip = vector(6, 0):rotate(angle) + pos
  local base = vector(-2, 0):rotate(angle) + pos
  local tail = vector(-6, 0):rotate(angle) + pos
  local wing1 = vector(-6, 4):rotate(angle) + pos
  local wing2 = vector(-6, -4):rotate(angle) + pos

  vtrifill(tip, wing1, base, 2)
  vtrifill(tip, wing2, base, 2)
  vline(tip, tail, 2)
end

function shooter:die()
  self.super.die(self)
  particles:spawn("shooter_die", self.pos.x, self.pos.y)
  self.timer:clear()
end

function shooter:fire_burst()
  self.timer:every(5, function()
    local aim = self.vel:copy()
    aim:set_mag(2)
    aim += self.vel
    add(enemy_bullets, enemy_bullet(self.pos, aim, 200))
  end, 3)
end