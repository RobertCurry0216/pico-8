bomber = enemy:extend()

function bomber:new(...)
  self.super.new(self, ...)
  self.vel = vector(0,3)
  self.max_speed = 3
  self.max_steer = 0.18 + rnd(0.4) 
end

function bomber:draw()
  self.super.draw(self)

  local dir = self.vel:norm() * 3
  local off = self.vel:norm()
  off:rotate(0.25)

  --body
  local head = self.pos + dir
  local tail = self.pos - dir

  vtrifill(head, tail+off, tail-off, 2)
  --line(head.x, head.y, tail.x, tail.y, 2)
end