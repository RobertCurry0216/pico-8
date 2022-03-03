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