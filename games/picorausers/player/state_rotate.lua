state_rotate = state:extend()
state_rotate.name = "rotate"

function state_rotate:update(p)
  if inputs.dx != 0 then
    p.heading:rotate(0.02*inputs.dx)
  end
  p.pos += p.momentum
  if p.pos.x < 0 then
    p.pos.x += width
  elseif p.pos.x > width then
    p.pos.x -= width
  end
  if p.pos.y < 0 then p.pos.y = 0 end
  if p.pos.y > height then p.pos.y = height end

  log(p.heading:angle())
end

function state_rotate:draw(p)
  circ(p.pos.x, p.pos.y, 10, 7)
  local endp = p.pos + p.heading*10
  line(p.pos.x, p.pos.y, endp.x, endp.y, 7)
end