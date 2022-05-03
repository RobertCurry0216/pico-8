stage = room:extend()

multiplier_timeout = 150
multiplier_target_base = 2
multiplier_offsets = {
  [1]={24, 8, 116},
  [2]={32, 8, 116},
  [4]={40, 8, 116},
  [8]={48, 8, 116},
  [16]={56, 16, 108},
  [32]={72, 17, 107},
  [64]={89, 17, 107}
}

function stage:new()
  play_time = t()

  -- reset stores
  bullets = {}
  enemies = {}
  enemy_bullets = {}
  particles.store = {}

  --score vars
  self.score = 0
  self.multiplier = 1
  self.m_timeout = 0
  self.m_target = multiplier_target_base
  self.streak = 0

  -- create player
  plr = player(width/2,height)

  --game director
  self.director = director(enemies)

  -- cam
  cam = follow_cam(plr)
  cam.bounds = {-128,0, width+128,height-128}

  --listeners
  self.listen_on_score = function(...) self:on_score(...) end
  register("score", self.listen_on_score)
end

function stage:update()
  self.director:update()

  bullets_update(bullets)
  bullets_update(enemy_bullets)
  particles:update()
  enemies_update(enemies, plr)
  bullets_collisions(bullets, enemies)
  bullets_collisions(enemy_bullets, {plr})
  plr:update()
  cam:update()

  if self.m_timeout > 0 then
    self.m_timeout -= 1
  else
    self.multiplier = 1
  end
end

function stage:draw()
  cls(7)

  circfill(plr.pos.x, plr.pos.y, 128*((plr.health+5)/plr_mx_health), 15)

  -- draw actors
  particles:draw()
  bullets_draw(bullets)
  bullets_draw(enemy_bullets)
  enemies_draw(enemies)
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

  --score
  local score_str = tostr(self.score, 0x2)
  score_str = sub("0000000000", 1, 10-#score_str)..score_str
  print(score_str, 2, 2, 2)

  --multiplier
  local sx, sw, dx = unpack(multiplier_offsets[self.multiplier])
  sspr(sx, 80, sw, 9, dx, 2)
  spr(174, dx-8, 6)
  if self.m_timeout > 0 then
    local m_remaining = 9 * (self.m_timeout / multiplier_timeout)
    line(126, 10, 126, 10 - m_remaining, 2)
  end

  --minimap
  rectfill(95,110,125,125,15)
  rectfill(95,122,125,125,7)
  rect(94,109,126,126,2)

  for e in all(enemies) do
    local ex = mid(map_to(e.pos.x, 0, width, 95, 125), 95, 125)
    local ey = mid(map_to(e.pos.y, 0, height, 110, 125), 110, 125)
    pset(ex, ey, 14)
  end

  local px = mid(map_to(plr.pos.x, 0, width, 95, 125), 95, 125)
  local py = mid(map_to(plr.pos.y, 0, height, 110, 125), 110, 125)
  pset(px, py, 2)
end

function stage:finish()
  unregister("score", self.listen_on_score)
  self.director:destroy()
end

function stage:on_score(value, x, y)
  --inc multiplier
  self.m_timeout = multiplier_timeout
  self.streak += 1
  if self.streak >= self.m_target then
    self.streak = 0
    self.m_target += 1
    self.multiplier = min(64, self.multiplier*2)
  end

  --add score
  local score = (value >> 16) * self.multiplier
  self.score += score
  if x != nil then
    particles:spawn("text", x, y, tostr(score, 0x2))
  end
end
