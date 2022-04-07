player = class:extend()
plr_mx_health = 50

function player:new(x,y)
  self.pos = vector(x, y)
  self.area = rect_area(x-4,y-4,8,8, true)
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
  self.health = plr_mx_health
  self.healing_delay = 0
  self.ram_damage=2
end

function player:update()
  self.sm:update(self)
  self.area.pos = self.pos

  -- shooting
  if inputs.shoot then
    self.weapon:shoot(self.pos, self.heading, self.momentum)
    cam:add_interest(plr.pos + plr.heading*50)
  elseif self.healing_delay == 0 then
  --healing
    self.health = min(self.health+0.25, plr_mx_health)
    if self.health != plr_mx_health then
      particles:spawn("debris", self.pos.x, self.pos.y)
    end
  else
    self.healing_delay = max(0, self.healing_delay - 1)
  end
end

function player:draw()
  --body
  local head = self.pos + self.heading*10
  local tail = self.pos - self.heading*10
  local mid = self.heading*2
  mid:rotate(0.25)
  --vline(head, tail, 2)
  vtrifill(head, self.pos+mid, self.pos-mid, 2)
  vtrifill(tail, self.pos+mid, self.pos-mid, 2)

  --wings
  local tip = self.heading*8*sin(self.heading:angle())
  tip:rotate(0.25)
  vtrifill(self.pos - tip, self.pos + tip, self.pos + self.heading*4, 2)

  --tail
  local tail_tip = self.heading*6*cos(self.heading:angle())
  tail_tip:rotate(-0.25)
  vtrifill(tail, tail+tail_tip, tail+self.heading*5, 2)
  local tail_cross = self.heading*3*sin(self.heading:angle())
  tail_cross:rotate(0.25)
  vline(tail+tail_cross, tail-tail_cross, 2)


  self.sm:draw(self)
  -- local x1, y1, x2, y2 = self.area:get_extents()
  -- rect(x1, y1, x2, y2, 9)
end

function player:on_hit(damage)
  emit("player_hit")
  cam:shake()
  self.health -= damage
  self.healing_delay = 30
  if self.health <= 0 then
    self:die()
  end
end

function player:die()
  goto_room(welcome)
end