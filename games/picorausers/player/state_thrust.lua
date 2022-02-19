state_thrust = state_rotate:extend()
state_thrust.name = "thrust"

function state_thrust:update(p)
  self.super:update(p)
  if not inputs.up then p.sm:goto_state("fall") end

  p.momentum += p.heading*0.3
  p.momentum:limit(4)
  local pos = p.pos - p.heading*8
  particles:spawn("circle", pos.x, pos.y)
end
