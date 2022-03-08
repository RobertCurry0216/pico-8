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
  plr = player(width/2,height)
  enemies = {}
  for i=1,10 do
    add(enemies, bomber(width/2, 0))
  end
  cam = follow_cam(plr)
  cam.bounds = {-64,0, width+64,height-128}
end

function _update()
  update_inputs()
  timer:update()
  bullets:update()
  particles:update()
  plr:update()
  for bmr in all(enemies) do
    bmr:update()
  end
  cam:update()
end

function _draw()
  cls(15)
  -- draw background
  for i=-1,16 do
    spr(16,128*i,0,16,3)
  end
  -- debug drawing
  line(0,0,0,height, 8)
  line(width,0,width,height, 11)

  bullets:draw()
  particles:draw()
  plr:draw()
  for bmr in all(enemies) do
    bmr:draw()
  end


  -- draw water
  local camy = cam.pos.y
  local camx = cam.pos.x
  local wl = water_line - camy
  if wl < 128 then
    --set GFX to use screen memory
    poke(0x5f54, 0x60)
    --pal({1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0})
    pal({1,14,3,4,5,6,6,8,9,10,11,12,13,14,7,0})

    sspr(0, 0, 127, wl, camx, water_line, 128, wl, false, true)
    --reset GFX
    poke(0x5f54, 0x00)
    pal()
  end
  line(left_max, water_line, right_max, water_line, 7)
end