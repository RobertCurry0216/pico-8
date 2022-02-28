function _init()
  target = vechicle(vector(rnd(128),rnd(128)), 12, random())
  persuer = vechicle(vector(rnd(128),rnd(128)), 8, evade)
end

function _update()
  timer:update()
  target:update()
  persuer:update(target)
end

function _draw()
  cls(5)
  target:draw()
  persuer:draw()
end