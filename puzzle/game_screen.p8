pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-------------------------------
--update functions
-------------------------------
function upd_game()
  if (btnp(left)) then block_move(player, -1, 0) end
  if (btnp(right)) then block_move(player, 1, 0) end
  if (btnp(up)) then block_move(player, 0, -1) end
  if (btnp(down)) then block_move(player, 0, 1) end
end

-------------------------------
--draw functions
-------------------------------
function drw_game()
  cls(peach)
  print("puzzle game",4,4,dark_gray)
  draw_board()
end