state_fall = state_rotate:extend()
state_fall.name = "fall"

function state_fall:update(p)
  self.super:update(p)
  p.momentum.y += 0.05
  p.momentum:limit(2)
  if inputs.up then
    p.sm:goto_state("thrust")
  end
end
