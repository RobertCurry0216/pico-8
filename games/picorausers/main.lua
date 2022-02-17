function _init()
  x = 64
end

function _update()
  x = 64 + sin(t()) * 16
end

function _draw()
  cls()
  circfill(x, 64, 20, 7)
end