function update_inputs()
  inputs = {
    left = btn(0),
    right = btn(1),
    up = btn(2),
    down = btn(3),
    o = btn(4),
    x = btn(5),
  }

  inputs.dx = tonum(inputs.right) - tonum(inputs.left)
end


function _init()
  tri = polygon(vector(64,64), 3, 14)
  sqr = polygon(vector(25, 100), 4, 20)
  sqr.heading = 0.125
end

function _update()
  update_inputs()
  tri:update()
end

function _draw()
  cls()
  color(6)
  sqr:draw()

  if tri:overlaps(sqr) then
    color(8)
  end

  tri:draw()
end