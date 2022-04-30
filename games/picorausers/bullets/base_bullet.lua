base_bullet = class:extend()

function base_bullet:new(p, h, t)
  self.pos = p
  self.vel = h
  self.dead = false
  self.area = rect_area(p.x,p.y,4,4,true)
  self.die_handler = timer:after(t, function() self:die() end)
  self.damage = 2
  self.max_speed = 4
end

function base_bullet:die()
  self.dead = true
  timer:cancel(self.die_handler)
  particles:spawn("smoke_puff", self.pos.x, self.pos.y)
end

function base_bullet:update()
  self.vel += self:steering()
  self.vel:limit(self.max_speed)
  self.pos += self.vel
  self.pos:wrap()
  self.area.pos = self.pos
end

function base_bullet:draw()
  circfill(self.pos.x, self.pos.y, 2, 2)
  --circfill(self.pos.x, self.pos.y, 1, 7)
end

function base_bullet:steering()
  return vector()
end