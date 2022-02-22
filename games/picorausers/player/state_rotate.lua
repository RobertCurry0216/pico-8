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
end

function vline(p1, p2, ...)
  line(p1.x, p1.y, p2.x, p2.y, ...)
end

function state_rotate:draw(p)
  --body
  local head = p.pos + p.heading*10
  local tail = p.pos - p.heading*10
  vline(head, tail, 2)

  --wings
  local tip = p.heading*5*sin(p.heading:angle())
  tip:rotate(0.25)
  vtrifill(p.pos - tip, p.pos + tip, p.pos + p.heading*8, 2)

  --tail
  local tail_tip = p.heading*6*cos(p.heading:angle())
  tail_tip:rotate(-0.25)
  vtrifill(tail, tail+tail_tip, tail+p.heading*5, 2)
end