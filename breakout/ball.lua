pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

ball_x = 64
ball_dx = 1
ball_y = 16
ball_dy = 1
ball_radius = 2
ball_colour = 11

function ball_update()
  ball_x += ball_dx
  ball_y += ball_dy
  ball_bounce()
end

function ball_bounce()
  if not (0 < ball_x and ball_x < 127) then
    ball_dx = ball_dx * -1
    sfx(0)
  end
  if not (0 < ball_y and ball_y < 127) then
    ball_dy = ball_dy * -1
    sfx(0)
  end
end

function ball_draw()
  circfill(ball_x, ball_y, ball_radius, ball_colour)
end