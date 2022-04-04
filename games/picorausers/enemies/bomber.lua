bomber = enemy:extend()

function bomber:new(x)
  self.super.new(self, x, -10)
  self.steering = seek(plr)
  self.vel = vector(0,3)
  self.max_speed = 3
  self.max_steer = 0.15 + rnd(0.1)
  self.area = rect_area(0,0,4,4,true)
  self.ram_damage = 8

  self.trail = 0
end

function bomber:update(...)
  self.super.update(self, ...)
  self.trail -= 1
  if self.trail == 0 then
    self.trail = 2
    particles:spawn("dot", self.pos.x, self.pos.y)
  end
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
end

function bomber:die()
  self.super.die(self)
  particles:spawn("smoke_cloud", self.pos.x, self.pos.y)
end