pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-------------------------------
--pallets
-------------------------------
pallet_main = {1, 6, 8, 12}
cbg, cmain, csec, ctrd = 0, 7, 8, 12
function set_pallet(pallet)
  pal(0, pallet[1])
  pal(7, pallet[2])
  pal(8, pallet[3])
  pal(12, pallet[4])
end


-------------------------------
--main game functions
-------------------------------

function _init()
  start_game()
end

function _update60()
  time += 1
  upd_game()
end

function _draw()
  set_pallet(pallet_main)
  rectfill(0, 0, 127, 512, 0)
  drw_game()
  draw_debug()
end

-------------------------------
--start game functions
-------------------------------
function start_game()
  time = 0
  player = m_player(64, 16)
  cam = m_cam(player)
end

-------------------------------
--update function
-------------------------------
function upd_game()
  player:update()
  cam:update()
  upd_bullets()
  upd_particles()
end

-------------------------------
--draw functions
-------------------------------
function drw_game()
  camera(cam:cam_pos())
  map(0,0,0,0,128,64)
  player:draw()
  drw_bullets()
  drw_particles()
end