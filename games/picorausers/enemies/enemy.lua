enemy = class:extend()

function enemy:new(x, y)
  self.pos = vector(x, y)
  self.vel = vector()
  self.max_speed = 2
  self.max_steer = 0.1
  self.steering = seek(plr)
  self.area = rect_area(x,y,4,4,true)
  self.dead = false
end

function enemy:update(plr)
  -- movement
  local s = self:steering()
  s:limit(self.max_steer)
  self.vel += s
  self.vel:set_mag(self.max_speed)
  self.pos += self.vel

  -- collisions
  self.area.pos = self.pos
  if self.area:overlaps(plr.area) then
    self.col = 8
  else
    self.col = 6
  end


  --cam:add_interest(self.pos)

  --wrap
  --TODO
end

function enemy:draw()
  local x1, y1, x2, y2 = self.area:get_extents()
  rect(x1, y1, x2, y2, self.col)
end

function enemy:die()
  self.dead = true
end