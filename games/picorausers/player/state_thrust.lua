state_thrust = state_fly:extend()
state_thrust.name = "thrust"

function state_thrust:update(p)
  self.super:update(p)
  if not inputs.thrust then p.sm:goto_state("fall", p) end

  p.momentum += p.heading*0.3
  p.momentum:limit(4)
  local pos = p.pos - p.heading*8
  particles:spawn("circle", pos.x, pos.y)

  --look ahead
  cam:add_interest(p.pos + p.heading*40)
end

function state_thrust:on_enter(p)
  p.turning_speed = 0.008
  music(0, 1)
end

function state_thrust:on_exit(p)
  music(-1)
end
