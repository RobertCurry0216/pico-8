welcome = room:extend()

function welcome:new()
end

function welcome:update()
  if inputs.up then
    goto_room(stage)
  end
end

function welcome:draw()
  camera()
  cls(15)

  --skull
  sspr(0,80, 24,25, 36,-1, 48,50)
  sspr(10,106, 12,6, 50,56, 24,12)

  
  --heading
  spr(128, 12, 46, 13, 2)

  --water
  poke(0x5f54, 0x60)
  pal({1,14,3,4,5,6,6,8,9,10,11,12,13,14,7,0})
  sspr(0,0, 128,64, 0,64, 128,64, false, true)
  --reset GFX
  poke(0x5f54, 0x00)
  pal()

  cprint("⬆️/🅾️ launch", 64, 86, 2)

end