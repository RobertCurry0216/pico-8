pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

spacemen = {}

function new_spaceman(r, a, s)
  local s = {
    angle = a,
    radius = r,
    drawangle = rnd(360),
    speed = s
  }
  add(spacemen, s)
  return s
end

function spacemen_upd()
  for s in all(spacemen) do
    s.drawangle += 1
    s.angle += 1
    s.radius -= 0.01
  end
end

function spacemen_draw()
  for s in all(spacemen) do
    local pos = angle(64, 64, s.radius, s.angle)
    scalespr("spaceman", pos.x, pos.y, 1, s.drawangle, black)
  end
end