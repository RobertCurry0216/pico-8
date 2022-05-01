enemy = class:extend()

function enemy:new(x, y)
  self.pos = vector(x, y)
  self.vel = vector()
  self.max_speed = 2
  self.max_steer = 0.1
  self.area = rect_area(0,0,4,4,true)
  self.dead = false
  self.health = 1
  self.score = 100
  self.ram_damage = 0
  self.difficulty = 1
end

function enemy:steering()
  return vector()
end

function enemy:update(plr)
  -- movement
  local s = self:steering()
  s:limit(self.max_steer)
  self.vel += s
  self.vel:limit(self.max_speed)
  self.pos += self.vel

  -- collisions
  self.area.pos = self.pos
  if self.area:overlaps(plr.area) then
    plr:on_ram(self.ram_damage)
    self:on_hit(plr.ram_damage)
  end

  if self.pos:to(plr.pos):magsq() < 10000 then
    cam:add_interest(self.pos)
  end

  --wrap
  self.pos:wrap()
end

function enemy:draw()
end

function enemy:die()
  self.dead = true
  cam:shake(7,1)
  emit("enemy_die", self)
end

function enemy:on_hit(damage)
  if self.dead then return end
  self.health -= damage
  if self.health <= 0 then
    emit("score", self.score, self.pos.x, self.pos.y - 10)
    self:die()
  end
end