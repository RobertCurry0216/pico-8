pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function new_game()
  --init sprites for rotation
  init_sprite(1, "plr")
  init_sprite(2, "spaceman")

  -- callbacks
  _upd = game_upd
  _drw = game_drw

  -- init vars
  plr = new_player()

  new_spaceman(rnd(24) + 24, rnd(360), rnd(8))
  new_spaceman(rnd(24) + 24, rnd(360), rnd(8))
  new_spaceman(rnd(24) + 24, rnd(360), rnd(8))
  new_spaceman(rnd(24) + 24, rnd(360), rnd(8))
end

function game_upd()
  bh_upd()
  spacemen_upd()
  plr:update()
end

function game_drw()
  cls(dark_blue)
  spacemen_draw()
  bh_drw()
  particles_drw()
  plr:draw()
end