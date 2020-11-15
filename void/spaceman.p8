pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function new_spaceman(r, a, s)
  local s = {
    angle = a,
    radius = r,
    drawangle = rnd(360),
    speed = s,
    decent = rnd(0.03) + 0.01
  }
  add(spacemen, s)
  return s
end

function spacemen_upd()
  if (#spacemen == 0) then
    current_task = "escape"
    return
  end

  for s in all(spacemen) do
    s.drawangle += 1
    local pos = angle(64, 64, s.radius, s.angle)
    --intersection checks
      --player
    if (abs(s.angle-plr.angle) <= 3 and abs(s.radius-plr.radius) <= 6) then
      --rescue
      del(spacemen, s)
      score_text = score_text.."웃"
      score += 1
      add_float(pos.x, pos.y-4,"+웃", blue)
    end
      --blackhole
    if (s.radius <= bh_size) then
      --die
      del(spacemen, s)  
      score_text = score_text.."x"
      bh_size += 4
      for _=1,8 do
        add_bh_particle(rnd(360), rnd(2)+1, rnd(4)+1, rnd(10)+15)
      end
      add_float(pos.x, pos.y,"-웃", dark_purple)
    end

    --adjust values
    s.angle = (s.angle + s.speed) % 360
    s.radius -= s.decent
  end
end

function spacemen_draw()
  for s in all(spacemen) do
    local pos = angle(64, 64, s.radius, s.angle)
    scalespr("spaceman", pos.x, pos.y, 1, s.drawangle, black)
  end
end
