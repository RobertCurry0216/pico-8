pico-8 cartridge // http://www.pico-8.com
version 18
__lua__


-------------------------------
--constructors
-------------------------------
function new_cube(x, y, pal)
  return {
    x = x,
    y = y,
    px = x,
    py = y,
    pal = pal,
    move = function (self, dx, dy)
      self.x += dx
      self.y += dy
    end,

    can_move = function (self, dx, dy)
      local _x, _y = self.x + dx, self.y + dy

      if _x < 1 or _x > 10 then return false end
      if _y > 19 then return false end
      if (_x > 0) and (_y > 0) then
        if static_cubes[_y][_x] != 0 then return false end
      end

      return true
    end,

    draw = function (self)
      spr(1, 2 + self.x * 6, self.y * 6, 6, 6)
      self.px = self.x
      self.py = self.y
    end
  }
end

function new_piece_s(x, y)
  local p = nil
  return {
    new_cube(x,   y,    p),
    new_cube(x-1, y,    p),
    new_cube(x,   y-1,  p),
    new_cube(x+1, y-1,  p)
  }
end
-------------------------------
--piece functions
-------------------------------

function piece_can_move(dx, dy)
  for cube in all(active_cubes) do
    if not cube:can_move(dx, dy) then 
      return false 
    end
  end
  return true
end

function piece_move(dx, dy)
  if not piece_can_move(dx, dy) then 
    return false 
  end
  for cube in all(active_cubes) do
    cube:move(dx, dy)
  end
  return true
end

function piece_rotate(dir)
  --move to 0,0
  dx = active_cubes[1].x
  dy = active_cubes[1].y
  for cube in all(active_cubes) do
    cube.x -= dx
    cube.y -= dy
  end
 
  -- apply rotation
  if dir == "left" then
    ang = 0.25
  else 
    ang = -0.25
  end
  for cube in all(active_cubes) do
    local xx, yy = cube.x, cube.y
    cube.x = xx*cos(ang) - yy*sin(ang)
    cube.y = xx*sin(ang) + yy*cos(ang)
  end

  --move back
  if not piece_move(dx, dy) then
    piece_rotate(dir == "left" and "right" or "left")
  end
end