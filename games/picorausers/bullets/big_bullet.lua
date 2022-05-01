big_bullet = base_bullet:extend()

function big_bullet:new(...)
  self.super.new(self, ...)
  self.damage = 12
  self.area = rect_area(0,0,12,12,true)
  self.max_speed = 2
end

function big_bullet:draw()
  circfill(self.pos.x, self.pos.y, 8, 2)
  circfill(self.pos.x, self.pos.y, 6, 7)
end

function big_bullet:die()
  self.super.die(self)
  for i=1,rnd(10)+10 do
    particles:spawn("smoke_puff", self.pos.x+rnd(12) - 6, self.pos.y+rnd(12) - 6, rnd(8))
  end
end