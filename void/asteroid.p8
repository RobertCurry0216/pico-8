pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function new_asteroid(r, a, s, sp)
  local ast = {
    angle = a,
    radius = r,
    size = s,
    speed = sp,
    decent = rnd(0.05) + 0.03
  }
  add(asteroids, ast)
  return ast
end

function asteroids_upd()
  for ast in all(asteroids) do
    local pos = angle(64, 64, ast.radius, ast.angle)
    --intersection checks
      --player
    if (abs(pos.x-plr.pos.x) <= ast.size + 1 and abs(pos.y-plr.pos.y) <= ast.size + 1) then
      --die
      plr.dead = true
      add_explosion(plr.pos.x, plr.pos.y)
      _upd = exploded_upd
      _drw = exploded_drw
      del(asteroids, ast)  
      return 
    end
      --blackhole
    if (ast.radius <= bh_size) then
      del(asteroids, ast)  
      bh_size += 2
      for _=1,8 do
        add_bh_particle(rnd(360), rnd(2)+1, rnd(4)+1, rnd(10)+15)
      end
      return
    end

    --adjust values
    ast.angle = (ast.angle + ast.speed) % 360
    ast.radius -= ast.decent
  end
end

function asteroids_draw()
  for ast in all(asteroids) do
    local pos = angle(64, 64, ast.radius, ast.angle)
    circfill(pos.x,pos.y,ast.size,dark_purple)
  end
end