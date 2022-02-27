base_bullet = class:extend()

function base_bullet:new(p, h, t)
  self.pos = p
  self.heading = h
  self.dead = false
  timer:after(t, function() self:die() end)
end

function base_bullet:die()
  self.dead = true
end

function base_bullet:update()
  self.pos += self.heading
end

function base_bullet:draw()
  circfill(self.pos.x, self.pos.y, 2, 2)
  circfill(self.pos.x, self.pos.y, 1, 7)
end