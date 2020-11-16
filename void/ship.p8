pico-8 cartridge // http://www.pico-8.com
version 18
__lua__


function new_player()
  return {
    angle = 0,
    maxspeed = 2,
    speed = 0,
    radius = 48,
    dead = false,
    update = player_upd,
    pos = {x=102, y=64},
    draw = player_drw
  }
end

function player_upd()
  if (plr.dead) return

  plr.pos = angle(64, 64, plr.radius, plr.angle)
  --check dead
  if (plr.radius <= bh_size - 4) then
    _upd = death_upd
    _drw = death_drw
    plr.dead = true
    return
  end

  --check escaped
  if (plr.radius > escape_radius) then
    plr.delta = angle(0, 0, plr.maxspeed, plr.angle + 90)
    plr.update = player_escaped_upd
    plr.draw = player_escaped_drw
    return
  end

  local dr = 0
  if (btn(up)) then 
    plr.speed = min(plr.speed + 0.3, plr.maxspeed)
    dr += 0.08
    -- smoke
    if (rnd(100) > 40) then 
      add_smoke(plr.pos.x, plr.pos.y)
    end
  else
    plr.speed *= 0.9
    dr -= (64 - plr.radius) / 64
  end

  plr.angle = (plr.angle + plr.speed) % 360
  plr.radius += dr
end

function player_drw()
  if (plr.dead) return
  scalespr("plr", plr.pos.x, plr.pos.y, 1, plr.angle + 180, black)
end

--escaped movement
function player_escaped_upd()
  plr.pos.x += plr.delta.x
  plr.pos.y += plr.delta.y

  --check off screen
  if (plr.pos.x < -4 or plr.pos.x > 130 or plr.pos.y < -4 or plr.pos.y > 130) then
    if (score > 0) then
      _upd = victory_upd
      _drw = victory_drw
    else
      _upd = fail_upd
      _drw = fail_drw
    end
  end
end

function player_escaped_drw(params)
  scalespr("plr", plr.pos.x, plr.pos.y, 1, plr.angle + 180, black)
end