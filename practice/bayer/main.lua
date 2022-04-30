function _init()

end

function _update()

end

function _draw()
  local l = (sin(t() / 16) + 1) / 2
  for y=0,127 do
    for x=0,127 do
      -- if dither(x,y, l) then
      --   pset(x,y,7)
      -- else
      --   pset(x,y,0)
      -- end
      pset(x,y,0)
      --dither(x,y, l)
    end
  end
end