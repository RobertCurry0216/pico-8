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

  timer:every(3, function()
    local a = self.heading:copy()
    shoot(base_bullet, self.pos + self.heading*5, a*3 + self.momentum, 60)
  end, 9999)
end

function player:update()
  self.sm:update(self)
end

function player:draw()
  self.sm:draw(self)
end