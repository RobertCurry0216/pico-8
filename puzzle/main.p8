pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

--utils
#include debug.p8
#include utils.p8
--classes
#include block.p8
#include game_board.p8
--screens
#include game_screen.p8


function _init()
  _upd=upd_game
  _drw=drw_game

  --global vars
  board_x, board_y=8, 4
  tile=8
  new_board(5,8)
  player = new_block(1,1)
  board_add(player)
end

function _update60()
  _upd()
end

function _draw()
  _drw()
  draw_debug()
end


__gfx__
000000000eeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000eddeddee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700ededdede0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000eeddedde0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000eddeddee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700ededdede0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000eeddedde0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000eeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
