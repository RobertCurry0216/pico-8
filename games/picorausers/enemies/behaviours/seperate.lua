function seperate(vechicle)
  --seperate
  local s = vector()
  local area = rect_area(vechicle.pos.x-10, vechicle.pos.y-10, 20, 20)
  for e in all(enemy_grid:get(area)) do
  -- for e in all(enemies) do
    if e != vechicle and (e.pos - vechicle.pos):magsq() < 100 then
      s -= (e.pos - vechicle.pos):norm()
    end
  end
  s:limit(1)
  return s
end
