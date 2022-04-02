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
  inputs.thrust = inputs.up or inputs.o
  inputs.shoot = inputs.x or inputs.down
end

function _init()
  goto_room(stage)
end

function _update()
  update_inputs()
  timer:update()
  current_room:update()
end

function _draw()
  current_room:draw()
end