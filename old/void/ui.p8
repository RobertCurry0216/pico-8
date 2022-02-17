pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function ui_drw()
  rectfill(0,0,127,8,black)
  rectfill(0,119,127,127,black)
  rect(0,0,127,8,indigo)
  rect(0,119,127,8,indigo)
  rect(0,0,127,127,indigo)
  print(score_text, 2,121,light_gray)
  print("task:"..current_task, 2,2,light_gray)
end