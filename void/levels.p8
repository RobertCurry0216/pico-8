pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function reset_vars()
  plr = new_player()
  score = 0
  score_text = ""
  current_task = "rescue"
  spacemen = {}
  particles = {}
  bh_particles = {}
  bh_size = 16
  escape_radius = 52
end

--level 1

function l1_cutscene()
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
  cls()
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
  count = 0
  text = "my friend is different"
end

function l2_cs_upd()
  t+= 1
  if (t%5 == 0) substr +=1
  if (btnp(fire2)) then
    if (count == 0) then
      text = "but others still need me"
      count += 1
      substr = 1
    else
      start_l2()
    end
  end
end

function l2_cs_drw()
  cls()
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
  cls()
  spr(8,32,32,8,8)
  print_centered(sub(text, 1, substr), light_gray, 0, 40)
  print("❎", 62, 108, indigo)
end

function start_l3()
  reset_vars()
  bh_size = 24

  new_spaceman(rnd(12) + 36, rnd(270)+45, rnd()+0.6)
  new_spaceman(rnd(12) + 36, rnd(270)+45, rnd()+0.5)
  new_spaceman(rnd(12) + 36, rnd(270)+45, rnd()+1.5)
  new_spaceman(rnd(12) + 36, rnd(270)+45, rnd()-1.5)

  _upd = game_upd
  _drw = game_drw
  next_level = l4_cutscene
end

