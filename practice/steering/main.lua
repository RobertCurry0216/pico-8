function _init()
  for i=1,25 do
    add(vechicles, vechicle(vector(rnd(128),rnd(128)), 3, flock, 1.2))
  end
end

function _update()
  timer:update()
  for v in all(vechicles) do
    v:update()
  end
end

function _draw()
  cls()
  for v in all(vechicles) do
    v:draw()
  end
end


-- function _init()
--   target = vector(rnd(128), rnd(128))
--   timer:every(30, function() target = vector(rnd(128), rnd(128)) end, 999999)
--   car = vechicle(vector(rnd(128), rnd(128)), 3, arrive, 1.2)
-- end

-- function _update()
--   timer:update()
--   car:update(target)
-- end

-- function _draw()
--   cls()
--   circfill(target.x, target.y, 3, 7)
--   car:draw()
-- end