pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
  frame = 0
end

function _update()
  frame += 1
  ball_update()
  paddle_update()
end

function _draw()
  cls(1)
  ball_draw()
  paddle_draw()

  --debug
  draw_debug()
end
