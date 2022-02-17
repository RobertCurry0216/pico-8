pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function reset_vars()
  plr = new_player()
  score = 0
  score_text = ""
  spacemen = {}
  asteroids = {}
  particles = {}
  bh_particles = {}
  bh_size = 16
  escape_radius = 52
  victory_text = "you saved "
  set_mode()
end

function set_mode(m)
  if (m == "consume") then
    current_task = "consume"
    end_task = "be consumed"
    victory_text = "you consumed "
    return
  end
  current_task = "rescue"
  end_task = "escape"
end

--level 1

function l1_cutscene()
  set_palette(1)
  _upd = l1_cs_upd
  _drw = l1_cs_drw
  t = 0
  substr = 1
end

function l1_cs_upd()
  t+= 1
  if (t%5 == 0) substr +=1
  if (btnp(fire2)) then
    start_l1()
  end
end

function l1_cs_drw()
  rectfill(0,0,128,128,black)
  spr(8,32,32,8,8)
  print_centered(sub("my friend is lost",1, substr), light_gray, 0, 40)
  print("❎", 62, 108, indigo)
end

function start_l1()
  reset_vars()
  bh_size = 16
  new_spaceman(rnd(12) + 32, rnd(270)+45, rnd()+0.5)

  _upd = game_upd
  _drw = game_drw
  next_level = l2_cutscene
end

--level 2

function l2_cutscene()
  _upd = l2_cs_upd
  _drw = l2_cs_drw
  t = 0
  substr = 1
  text = "my friend is not the same"
end

function l2_cs_upd()
  t+= 1
  if (t%5 == 0) substr +=1
  if (btnp(fire2)) then
    start_l2()
  end
end

function l2_cs_drw()
  rectfill(0,0,128,128,black)
  spr(8,32,32,8,8)
  print_centered(sub(text, 1, substr), light_gray, 0, 40)
  print("❎", 62, 108, indigo)
end

function start_l2()
  reset_vars()
  bh_size = 20
  new_spaceman(rnd(12) + 32, rnd(270)+45, rnd()+0.6)
  new_spaceman(rnd(12) + 32, rnd(270)+45, rnd()+0.5)
  new_spaceman(rnd(12) + 32, rnd(270)+45, rnd()-1.5)

  _upd = game_upd
  _drw = game_drw
  next_level = l3_cutscene
end

--level 3

function l3_cutscene()
  _upd = l3_cs_upd
  _drw = l3_cs_drw
  t = 0
  substr = 1
  count = 0
  text = "they are all different"
end

function l3_cs_upd()
  t+= 1
  if (t%5 == 0) substr +=1
  if (btnp(fire2)) then
    if (count == 0) then
      text = "they are consumed"
      count += 1
      substr = 1
    else
      start_l3()
    end
  end
end

function l3_cs_drw()
  rectfill(0,0,128,128,black)
  spr(8,32,32,8,8)
  print_centered(sub(text, 1, substr), light_gray, 0, 40)
  print("❎", 62, 108, indigo)
end

function start_l3()
  reset_vars()
  bh_size = 24

  new_spaceman(rnd(12) + 36, rnd(270)+45, rnd()+0.5)
  new_spaceman(rnd(12) + 36, rnd(270)+45, rnd()+0.5)
  new_spaceman(rnd(12) + 36, rnd(270)+45, rnd()-1.5)

  new_asteroid(45, rnd(270)+45, 3, 0.8)

  _upd = game_upd
  _drw = game_drw
  next_level = l4_cutscene
end

--level 4

function l4_cutscene()
  set_palette(2)
  _upd = l4_cs_upd
  _drw = l4_cs_drw
  t = 0
  substr = 1
  count = 0
  text = "it is the void"
end

function l4_cs_upd()
  t+= 1
  if (t%5 == 0) substr +=1
  if (btnp(fire2)) then
    if (count == 0) then
      text = "it is consuming me too"
      count += 1
      substr = 1
    else
      start_l4()
    end
  end
end

function l4_cs_drw()
  rectfill(0,0,128,128,black)
  spr(8,32,32,8,8)
  print_centered(sub(text, 1, substr), light_gray, 0, 40)
  print("❎", 62, 108, indigo)
end

function start_l4()
  reset_vars()
  bh_size = 26

  new_spaceman(rnd(12) + 40, rnd(270)+45, rnd()+0.6)
  new_spaceman(rnd(12) + 40, rnd(270)+45, rnd()+0.5)

  new_asteroid(rnd(20) + 32, rnd(270)+45, rnd(3)+2, rnd())

  _upd = game_upd
  _drw = game_drw
  next_level = l5_cutscene
end

--level 5

function l5_cutscene()
  _upd = l5_cs_upd
  _drw = l5_cs_drw
  bh_particles = {}
  bh_size = 30
  t = 0
  substr = 1
  count = 0
  text = "i can feel its pull"
end

function l5_cs_upd()
  bh_upd()
  t+= 1
  if (t%5 == 0) substr +=1
  if (btnp(fire2)) then
    if (count == 0) then
      text = "it is staring back"
      count += 1
      substr = 1
    else
      start_l5()
    end
  end
end

function l5_cs_drw()
  rectfill(0,0,128,128,black)
  bh_drw(1)
  spr(8,32,32,8,8)
  print_centered(sub(text, 1, substr), light_gray, 0, 40)
  print("❎", 62, 108, indigo)
end

function start_l5()
  reset_vars()
  bh_size = 28

  for _=1,2 do
    new_spaceman(rnd(12) + 40, rnd(270)+45, rnd()+0.6)
  end
  for _=1,3 do
    new_asteroid(rnd(20) + 32, rnd(270)+45, rnd(3)+2, rnd()+0.8)
  end

  _upd = game_upd
  _drw = game_drw
  next_level = l6_cutscene
end


--level 6

function l6_cutscene()
  _upd = l6_cs_upd
  _drw = l6_cs_drw
  bh_particles = {}
  bh_size = 45
  t = 0
  substr = 1
  text = "there is nothing left of me"
end

function l6_cs_upd()
  bh_upd()
  t+= 1
  if (t%5 == 0) substr +=1
  if (btnp(fire2)) then
    start_l6()
  end
end

function l6_cs_drw()
  rectfill(0,0,128,128,black)
  bh_drw(1)
  spr(8,32,32,8,8)
  print_centered(sub(text, 1, substr), light_gray, 0, 40)
  print("❎", 62, 108, indigo)
end

function start_l6()
  reset_vars()
  bh_size = 30

  for _=1,4 do
    new_spaceman(rnd(12) + 40, rnd(270)+45, rnd()+0.6)
  end
  for _=1,2 do
    new_asteroid(rnd(20) + 40, rnd(270)+45, rnd(4)+1, rnd()-1.4)
  end

  _upd = game_upd
  _drw = game_drw
  next_level = l7_cutscene
end

-- todo levels

--level 7

function l7_cutscene()
  set_palette(3)
  _upd = l7_cs_upd
  _drw = l7_cs_drw
  bh_particles = {}
  bh_size = 56
  t = 0
  substr = 1
  count = 0
  text = "all that is left"
end

function l7_cs_upd()
  bh_upd()
  t+= 1
  if (t%5 == 0) substr +=1
  if (btnp(fire2)) then
    if (count == 0) then
      text = "is to consume"
      count += 1
      substr = 1
    else
      start_l7()
    end
  end
end

function l7_cs_drw()
  rectfill(0,0,128,128,black)
  bh_drw()
  spr(8,32,32,8,8)
  print_centered(sub(text, 1, substr), light_gray, 0, 40)
  print("❎", 62, 108, indigo)
end

function start_l7()
  reset_vars()
  set_mode("consume")
  plr.radius = 52
  bh_size = 32

  for _=1,4 do
    new_spaceman(rnd(6) + 46, rnd(270)+45, rnd()+0.6)
  end

  new_asteroid(rnd(10) + 40, rnd(270)+45, rnd(4)+1, rnd()-1.4)


  _upd = game_upd
  _drw = game_drw
  next_level = l8_cutscene
end

--level 8

function l8_cutscene()
  _upd = l8_cs_upd
  _drw = l8_cs_drw
  bh_particles = {}
  bh_size = 56
  t = 0
  substr = 1
  count = 0
  text = " . . . "
end

function l8_cs_upd()
  bh_upd()
  t+= 1
  if (t%5 == 0) substr +=1
  if (btnp(fire2)) then
    if (count == 0) then
      text = "i like this"
      count += 1
      substr = 1
    else
      start_l8()
    end
  end
end

function l8_cs_drw()
  rectfill(0,0,128,128,black)
  bh_drw()
  spr(8,32,32,8,8)
  print_centered(sub(text, 1, substr), light_gray, 0, 40)
  print("❎", 62, 108, indigo)
end

function start_l8()
  reset_vars()
  set_mode("consume")
  plr.radius = 52
  bh_size = 36

  for _=1,4 do
    new_spaceman(rnd(6) + 46, rnd(270)+45, rnd()+0.6)
  end
  for _=1,2 do
    new_asteroid(rnd(6) + 44, rnd(270)+45, rnd(4)+1, rnd()-1.4)
  end

  _upd = game_upd
  _drw = game_drw
  next_level = l9_cutscene
end

--level 9

function l9_cutscene()
  _upd = l9_cs_upd
  _drw = l9_cs_drw
  bh_particles = {}
  bh_size = 56
  t = 0
  substr = 1
  text = "i must consume"
end

function l9_cs_upd()
  bh_upd()
  t+= 1
  if (t%5 == 0) substr +=1
  if (btnp(fire2)) then
    start_l10()
  end
end

function l9_cs_drw()
  rectfill(0,0,128,128,black)
  bh_drw()
  spr(8,32,32,8,8)
  print_centered(sub(text, 1, substr), light_gray, 0, 40)
  print("❎", 62, 108, indigo)
end

function start_l9()
  reset_vars()
  set_mode("consume")
  plr.radius = 52
  bh_size = 40

  for _=1,6 do
    new_spaceman(rnd(2) + 50, rnd(270)+45, rnd()+0.6)
  end
  new_asteroid(rnd(20) + 28, rnd(270)+45, rnd(3) + 1, rnd()-1.4)

  _upd = game_upd
  _drw = game_drw
  next_level = l10_cutscene
end

--level 10

function l10_cutscene()
  _upd = l10_cs_upd
  _drw = l10_cs_drw
  bh_particles = {}
  bh_size = 56
  t = 0
  substr = 1
  text = "i am void"
end

function l10_cs_upd()
  bh_upd()
  t+= 1
  if (t%5 == 0) substr +=1
  if (btnp(fire2)) then
    goto_splash()
  end
end

function l10_cs_drw()
  rectfill(0,0,128,128,black)
  bh_drw()
  print_centered(sub(text, 1, substr), light_gray, 0, 0)
end
