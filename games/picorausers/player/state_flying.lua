state_fly = state_rotate:extend()
state_fly.name = "fly"

function state_fly:update(p)
  self.super:update(p)

  local h = p.heading:angle()
  h -= 0.25
  if h < 0.5 then
    p.heading:rotate(h*0.3)
  else
    p.heading:rotate((h-1)*0.3)
  end
end