inputs = {}


function update_inputs()
  inputs = {
    left = btn(0),
    right = btn(1),
    up = btn(2),
    down = btn(3),
    o = btn(4),
    x = btn(5),
    any = btn() != 0
  }

  inputs.dx = tonum(inputs.right) - tonum(inputs.left)
  inputs.thrust = inputs.up or inputs.o
  inputs.shoot = inputs.x or inputs.down
end

function _init()
  play_time = t()
  cam = follow_cam({pos=vector(width/2,height/2)})
  goto_room(welcome)
end

function _update()
  update_inputs()
  timer:update()
  current_room:update()
end

function _draw()
  current_room:draw()
end