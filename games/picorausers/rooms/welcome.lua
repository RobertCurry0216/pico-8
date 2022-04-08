welcome = room:extend()

function welcome:new()
  camera()
end

function welcome:update()
  if inputs.any then
    goto_room(stage)
  end
end

function welcome:draw()
  cls(15)
  cprint("picorausers", 64, 64, 2)
end