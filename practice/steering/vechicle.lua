vechicle = class:extend()

function vechicle:new(pos, col, steering)
  self.pos = pos
  self.vel = vector(0,0)
  self.col = col
  self.steering = steering
  self.max_speed = 2
end

function vechicle:update(target)
  local s = self.steering(self, target)
  self.vel += s
  self.vel:limit(self.max_speed)
  self.pos += self.vel
  self:wrap()
end

function vechicle:draw()
  local e = self.pos + (self.vel * 3)
  line(self.pos.x, self.pos.y, e.x, e.y, self.col)
  circfill(self.pos.x, self.pos.y, 2)
end

function vechicle:wrap()
  if self.pos.x > 128 then
    self.pos.x -= 128
  elseif self.pos.x < 0 then
    self.pos.x += 128
  end

  if self.pos.y > 128 then
    self.pos.y -= 128
  elseif self.pos.y < 0 then
    self.pos.y += 128
  end
end