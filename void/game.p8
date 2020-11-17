pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function new_game()
  --start level 1
  l1_cutscene()
end

------------------------
--game states
------------------------1

function goto_splash()
  bh_particles = {}
  bh_size = 56
  _upd = splash_upd
  _drw = splash_drw
end

--splash screen
function splash_upd()
  bh_upd()
  if (btn(fire2)) then
    new_game()
  end
end

function splash_drw()
  rectfill(0,0,128,128,black)
  bh_drw()
  spr(128,0,32,16,8)
  print("❎", 62, 108, indigo)
end

--in game
function game_upd()
  bh_upd()
  spacemen_upd()
  asteroids_upd()
  plr:update()
end

function game_drw()
  rectfill(0,0,128,128,black)
  spacemen_draw()
  asteroids_draw()
  bh_drw()
  particles_drw()
  plr:draw()
  ui_drw()
end

-- death transition
function death_upd()
  bh_size += 0.5
  game_upd()

  if (bh_size > 127) then
    _upd = continue_upd
    _drw = continue_drw
  end
end

function death_drw()
  rectfill(0,0,128,128,black)
  spacemen_draw()
  particles_drw()
  ui_drw()
  bh_drw()
end

-- continue screen
function print_centered(str, c, dx, dy)
  dx = true and dx or 0
  dy = true and dy or 0
  print(str, 64 - (#str * 2) + dx, 60 + dy, c) 
end

function continue_drw()
  rectfill(0,0,128,128,black)
  print_centered("you were consumed by the void", dark_blue)
  print("❎", 62, 108, indigo)
end

function continue_upd()
  if (btnp(fire2)) then
    goto_splash()
  end
end

--victory screen
function victory_upd()
  bh_upd()
  spacemen_upd()
  if (btnp(fire2)) then
    next_level()
  end
end

function victory_drw()
  game_drw()
  print_centered("you escaped the void", indigo, 0, -4)
  print_centered("you saved "..score.." soul"..(score==1 and "" or "s"), indigo, 0, 4)
  print("❎", 62, 108, indigo)
end

--fail screen
function fail_upd()
  bh_upd()
  spacemen_upd()
  if (btnp(fire2)) then
    goto_splash()
  end
end

function fail_drw()
  game_drw()
  print_centered("you failed to save anyone", indigo, 0, -8)
  print_centered("except yourself", dark_purple)
  print_centered("❎", indigo, 0, 8)
end