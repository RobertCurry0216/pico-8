enemy_bullet = base_bullet:extend()

function enemy_bullet:new(...)
  self.super.new(self, ...)
  self.damage = 3
end

function enemy_bullet:draw()
  circfill(self.pos.x, self.pos.y, 2, 2)
  circfill(self.pos.x, self.pos.y, 1, 7)
end