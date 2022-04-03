base_bullet = class:extend()

function base_bullet:new(p, h, t)
  self.pos = p
  self.heading = h
  self.dead = false
  self.area = rect_area(p.x,p.y,4,4,true)
  self.handler = timer:after(t, function() self:die() end)
  self.damage = 2
end

function base_bullet:die()
  self.dead = true
  timer:cancel(self.handler)
  particles:spawn("smoke_puff", self.pos.x, self.pos.y)
end

function base_bullet:update()
  self.pos += self.heading
  self.pos:wrap()
  self.area.pos = self.pos
end

function base_bullet:draw()
  circfill(self.pos.x, self.pos.y, 2, 2)
  --circfill(self.pos.x, self.pos.y, 1, 7)
end