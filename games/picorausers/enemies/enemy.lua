enemy = class:extend()

function enemy:new(x, y)
  self.pos = vector(x, y)
  self.vel = vector()
  self.max_speed = 2
  self.steering = seek(plr)
end

function enemy:update()
  local s = self:steering()
  self.pos += s

  --wrap
  --TODO
end

function enemy:draw()
  circfill(self.pos.x, self.pos.y, 3, 8)
end