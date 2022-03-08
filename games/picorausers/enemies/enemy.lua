enemy = class:extend()

function enemy:new(x, y)
  self.pos = vector(x, y)
  self.vel = vector()
  self.max_speed = 2
  self.max_steer = 0.1
  self.steering = seek(plr)
end

function enemy:update()
  local s = self:steering()
  s:limit(self.max_steer)
  self.vel += s
  self.vel:set_mag(self.max_speed)
  self.pos += self.vel


  --cam:add_interest(self.pos)

  --wrap
  --TODO
end

function enemy:draw()

end