pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

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
  cls()
  camera(cam:cam_pos())
  map(0,0,0,0)
  player:draw()
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
end
