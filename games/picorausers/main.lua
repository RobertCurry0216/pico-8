inputs = {}

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
  plr = player(64,64)
end

function _update()
  update_inputs()
  particles:update()
  plr:update()
end

function _draw()
  cls()
  particles:draw()
  plr:draw()
end