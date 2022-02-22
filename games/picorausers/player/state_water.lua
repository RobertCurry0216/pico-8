state_water = state_rotate:extend()
state_water.name = "water"

function state_water:update(p)
  self.super:update(p)

  local h = p.heading:angle()
  h -= 0.25
  if h < 0.5 then
    p.heading:rotate(h*0.1)
  else
    p.heading:rotate((h-1)*0.1)
  end

  p.momentum += p.heading*(0.3 + tonum(inputs.up)*0.2)

  if p.pos.y <= water_line then
    p.sm:goto_state("thrust")
  end
end
