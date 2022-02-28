player = class:extend()

function player:new(x,y)
  self.pos = vector(x, y)
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
  if inputs.shoot then
    self.weapon:shoot(self.pos, self.heading, self.momentum)
  end
end

function player:draw()
  self.sm:draw(self)
end