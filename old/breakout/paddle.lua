pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-------------------------------
--paddle vars
-------------------------------
paddle_x = 64
paddle_speed = 5
paddle_dx = 0
paddle_y = 112
paddle_width = 48

-------------------------------
--paddle main functions
-------------------------------

function paddle_update()
  paddle_move()
end

function paddle_draw()
  spr(2, paddle_x, paddle_y)
  sspr(23, 0, 1, 8, paddle_x + 8, paddle_y, paddle_width - 16, 8)
  spr(2, paddle_x + paddle_width - 8, paddle_y, 1, 1, true)
end

-------------------------------
--paddle movement
-------------------------------
function paddle_move()
  if btn(1) then
    paddle_dx = paddle_speed
  elseif btn(0) then
    paddle_dx = -paddle_speed
  else
    paddle_dx /= 1.2
  end
  paddle_x += paddle_dx
  paddle_x = clamp(0, 128 - paddle_width, paddle_x)
end

