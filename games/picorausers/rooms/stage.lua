stage = room:extend()

function stage:new()
  -- reset stores
  bullets = {}
  enemies = {}
  particles.store = {}

  -- create player
  plr = player(width/2,height)

  -- cam
  cam = follow_cam(plr)
  cam.bounds = {-128,0, width+128,height-128}

  --temp
  for i=1,20 do
    add(enemies, bomber(width/2, 0))
  end
end

function stage:update()
  bullets_update(bullets)
  particles:update()
  enemies_update(enemies, plr)
  plr:update()
  cam:update()
end

function stage:draw()
  cls(7)

  circfill(plr.pos.x, plr.pos.y, 128*((plr.health+5)/plr_mx_health), 15)

  -- debug drawing
  --line(0,0,0,height, 8)
  --line(width,0,width,height, 11)

  -- draw actors

  bullets_draw(bullets)
  enemies_draw(enemies)
  particles:draw()
  plr:draw()

  -- draw background
  for i=-1,16 do
    spr(16,128*i,0,16,3)
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


  --ui
  camera()
  --print(plr.health, 2, 2, 2)
end
