state_fly = state_rotate:extend()
state_fly.name = "fly"

function state_fly:update(p)
  self.super:update(p)

  if p.pos.y > water_line then
    p.sm:goto_state("water", p)
  end
end