pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

paddle_x = 64
paddle_speed = 5
paddle_dx = 0
paddle_y = 112
paddle_width = 24

function paddle_update()
  if btn(1) then
    paddle_dx = paddle_speed
  elseif btn(0) then
    paddle_dx = -paddle_speed
  else
    paddle_dx /= 1.2
  end
  paddle_x += paddle_dx
  paddle_x = clamp(12, 116, paddle_x)
end

function paddle_draw()
  spr(2, paddle_x - 12, paddle_y)
  spr(3, paddle_x - 4, paddle_y)
  spr(2, paddle_x + 4, paddle_y, 1, 1, true)
end