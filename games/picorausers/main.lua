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
  -- draw background
  rectfill(left_max,0,right_max,height,15)
  for i=-1,16 do
    spr(16,128*i,0,16,3)
  end
  -- debug drawing
  line(0,0,0,height, 8)
  line(width,0,width,height, 11)

  camera(plr.pos.x-64, mid(plr.pos.y-64, 0, height - 128))
  particles:draw()
  plr:draw()


  -- draw water
  local camy = mid(plr.pos.y-64, 0, height - 128)
  local camx = plr.pos.x-64
  local wl = water_line - camy
  if wl < 128 then
    --set GFX to use screen memory
    poke(0x5f54, 0x60)
    pal(15,12)
    sspr(0, 0, 127, wl, camx, water_line, 127, wl, false, true)
    pal()
    --reset GFX
    poke(0x5f54, 0x00)
  end
  line(left_max, water_line, right_max, water_line, 7)
end