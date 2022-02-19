player = class:extend()

function player:new(x,y)
  self.pos = vector(x, y)
  self.heading = vector(0,-1)
  self.momentum = vector(0,0)
  self.sm = statemachine:new(
    state_fall,
    state_thrust
  )
end

function player:update()
  self.sm:update(self)
  --log(self.sm.state.name, "h", self.heading, "m", self.momentum, "p", self.pos)
end

function player:draw()
  self.sm:draw(self)
end