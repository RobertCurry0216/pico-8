player = class:extend()

function player:new(x,y)
  self.pos = vector(x, y)
  self.area = rect_area(vector(x-4,y-4), vector(8,8))
  self.area.offset = vector(4,4)
  self.heading = vector(0,-1)
  self.momentum = vector(0,0)
  self.turning_speed = 0.02
  self.sm = statemachine:new(
    state_fall,
    state_thrust,
    state_water
  )
  self.sm.p = self
  self.weapon = weapon(base_bullet)
end

function player:update()
  self.sm:update(self)
  self.area.pos = self.pos - self.area.offset
  if inputs.shoot then
    self.weapon:shoot(self.pos, self.heading, self.momentum)
  end
end

function player:draw()
  self.sm:draw(self)
  -- rect(
  --   self.area.pos.x,
  --   self.area.pos.y,
  --   (self.area.pos + self.area.size).x,
  --   (self.area.pos + self.area.size).y,
  --   6
  -- )
end