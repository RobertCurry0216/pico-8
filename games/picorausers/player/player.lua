player = class:extend()

function player:new(x,y)
  self.pos = vector(x, y)
  self.heading = vector(0,-1)
  self.momentum = vector(0,0)
  self.sm = statemachine:new(
    state_fall,
    state_thrust,
    state_water
  )
end

function player:update()
  self.sm:update(self)
end

function player:draw()
  self.sm:draw(self)
end