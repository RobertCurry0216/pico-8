pico-8 cartridge // http://www.pico-8.com
version 18
__lua__


-------------------------------
--game functions
-------------------------------
function _init()
  initgame()
  time = 0
end

function _update60()
  time += 1
  upd_function()
end

function _draw()
  drw_game()
  
  draw_debug()
end

-------------------------------
--new game
-------------------------------
function initgame()
  score = 0
  clear_board = true
  game_state:set"spawn_new_piece"

  static_cubes = {}
  active_cubes = {}
  static_cubes = {}
  for i=1, 20 do
    static_cubes[i] = {}
    for j=1, 10 do
      static_cubes[i][j] = 0
    end
  end
end

