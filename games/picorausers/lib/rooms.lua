room = class:extend()
current_room = nil

function room:new()

end

function room:update()

end

function room:draw()

end

function room:finish()

end

--helper functions
function goto_room(r, ...)
  if current_room then current_room:finish() end
  current_room = r(...)
end