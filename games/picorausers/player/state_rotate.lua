state_rotate = state:extend()
state_rotate.name = "rotate"

function state_rotate:update(p)
  if inputs.dx != 0 then
    p.heading:rotate(p.turning_speed*inputs.dx)
  end
  p.pos += p.momentum
  p.pos:wrap()
  if p.pos.y < 0 then p.pos.y = 0 end
  if p.pos.y > height then p.pos.y = height end
end

function state_rotate:draw(p)

end