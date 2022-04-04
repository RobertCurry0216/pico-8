welcome = room:extend()

function welcome:new()

end

function welcome:update()
  if inputs.any then
    goto_room(stage)
  end
end

function welcome:draw()
  cls(15)
  print("picorausers", 20, 60, 2)
end