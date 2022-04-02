bomber = enemy:extend()

function bomber:new()
  self.super.new(self, plr.pos.x + rnd(50) - 25, -10)
  self.vel = vector(0,3)
  self.max_speed = 3 + rnd(1)
  self.max_steer = 0.15 + rnd(0.1)
  self.area = rect_area(0,0,4,4,true)
  self.damage = 5

  self.tail = 5
end

function bomber:update(...)
  self.super.update(self, ...)
  self.tail -= 1
  if self.tail == 0 then
    self.tail = 2
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