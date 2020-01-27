pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

ball_x = 64
ball_dx = 1.8
ball_y = 16
ball_dy = 1.8
ball_radius = 2
ball_colour = 11

function ball_update()
  ball_x += ball_dx
  ball_y += ball_dy
  ball_bounce_wall()
  bounce_ball_paddle()
end

function ball_draw()
  circfill(ball_x, ball_y, ball_radius, ball_colour)
end

-------------------------------
--ball collision function
-------------------------------

function bounce_ball_paddle()
  if ((ball_y - ball_dy - 8) > paddle_y) return

  if (ball_y + ball_radius) > paddle_y then
    local _ball = flr(ball_x)
    if clamp(paddle_x, paddle_x + paddle_width, _ball) == _ball then
      ball_dy *= -1
      sfx(0)
    end
  end
end

function ball_bounce_wall()
  if not (0 < ball_x and ball_x < 127) then
    ball_dx *= -1
    sfx(0)
  end
  if ball_y < 0 then
    ball_dy *= -1
    sfx(0)
  end
end
