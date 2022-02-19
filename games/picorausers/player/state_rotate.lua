state_rotate = state:extend()
state_rotate.name = "rotate"

function state_rotate:update(p)
  if inputs.dx != 0 then
    p.heading:rotate(0.02*inputs.dx)
  end
  p.pos += p.momentum
end

function state_rotate:draw(p)
  circ(p.pos.x, p.pos.y, 10, 7)
  local endp = p.pos + p.heading*10
  line(p.pos.x, p.pos.y, endp.x, endp.y, 7)
end