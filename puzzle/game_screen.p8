pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-------------------------------
--update functions
-------------------------------
function upd_game()

end

-------------------------------
--draw functions
-------------------------------
function drw_game()
  cls(peach)
  rectfill(32,16,96,80,indigo)
  rect(32,16,96,80,brown)
  print("puzzle game",4,4,dark_gray)
end