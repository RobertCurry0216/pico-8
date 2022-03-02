state_fall = state_fly:extend()
state_fall.name = "fall"

function state_fall:update(p)
  self.super:update(p)
  p.momentum.y += 0.05
  p.momentum:limit(2)
  if inputs.thrust then
    p.sm:goto_state("thrust", p)
  end
end


function state_fall:on_enter(p)
  p.turning_speed = 0.02
end