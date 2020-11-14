pico-8 cartridge // http://www.pico-8.com
version 18
__lua__


function new_player()
  return {
    angle = 0,
    maxspeed = 2,
    speed = 0,
    radius = 48,
    update = player_upd,
    draw = player_drw
  }
end

function player_upd()
  local dr = 0
  if (btn(up)) then 
    plr.speed = min(plr.speed + 0.3, plr.maxspeed)
    dr += 0.08
    -- smoke
    if (rnd(100) > 40) then 
      local pos = angle(64, 64, plr.radius, plr.angle)
      add_smoke(pos.x, pos.y)
    end
  else
    plr.speed *= 0.9
    dr -= (64 - plr.radius) / 64
  end

  plr.angle = (plr.angle + plr.speed) % 360
  plr.radius += dr
end

function player_drw()
  local pos = angle(64, 64, plr.radius, plr.angle)
  scalespr("plr", pos.x, pos.y, 1, plr.angle + 180, black)
end