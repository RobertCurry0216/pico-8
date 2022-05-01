game_over = room:extend()

function game_over:new(score)
  self.ready = false
  timer:after(90, function() self.ready = true end)
  local score_str = tostr(score, 0x2)
  self.score = sub("0000000000", 1, 10-#score_str)..score_str
  self.time = tostr(ceil(t() - play_time)).."S"
end

function game_over:update()
  if self.ready and (inputs.x or inputs.o) then
    goto_room(welcome)
  end

  bullets_update(bullets)
  bullets_update(enemy_bullets)
  particles:update()
  enemies_update(enemies, plr)

  cam:update()
end

function game_over:draw()
  cls(15)

  -- draw actors

  particles:draw()
  bullets_draw(bullets)
  bullets_draw(enemy_bullets)
  enemies_draw(enemies)

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

  --game over screen
  camera()

  spr(195, 20, 24, 11, 2)

  cprint("score:", 64, 56, 2)
  cprint(self.score, 64, 64, 2)

  cprint("time:", 64, 80, 2)
  cprint(self.time, 64, 88, 2)

  if self.ready then
    cprint("❎/🅾️ retry", 62, 104, 2)
  end
end