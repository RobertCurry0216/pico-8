pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-------------------------------
--game states
-------------------------------

game_state = {
  set = function (self, state)
    upd_function = self[state]
  end
}

game_state.spawn_new_piece = function ()
  fall_timer = 0
  active_cubes = new_piece_s(5, -1)
  game_state:set"move_piece"
end

game_state.move_piece = function ()
  -- rotation
  if btnp(2) then
    piece_rotate"left"
  end

  --fall faster
  if (btn(3)) fall_timer += 2

  -- movement 
  if (btnp(0)) piece_move(-1, 0)
  if (btnp(1)) piece_move(1, 0)
  
  fall_timer += 1
  if fall_timer > 20 then
    fall_timer = 0
    if piece_can_move(0, 1) then
      piece_move(0, 1)
    else
      -------------------------------
      --land piece
      -------------------------------
      for cube in all(active_cubes) do
        static_cubes[cube.y][cube.x] = cube
      end
      active_cubes = {}
      -- check for completed rows
      for row in all(static_cubes) do
        local row_done = true
        for cube in all(static_cubes) do
          if cube == 0 then row_done = false end
        end
        if row_done then 
          del(static_cubes, row) 
          add(static_cubes, {0,0,0,0,0,0,0,0,0,0})
        end
      end

      clear_board = true

      game_state:set"spawn_new_piece"
    end
  end
end

-------------------------------
--draw function
------------------------------- 
function drw_game()
  --draw game area
  if clear_board then
    cls(1)
    clear_board = false
    for row in all(static_cubes) do
      for cube in all(row) do
        if cube != 0 then cube:draw"" end
      end
    end
  end
  
  rectfill2(0, 0, 8, 127, 2)
  rectfill2(0, 120, 127, 16, 2)
  rectfill2(68, 0, 64, 127, 2)

  for cube in all(active_cubes) do
    rectfill2(2 + cube.px * 6, cube.py * 6, 6, 6, 1)
  end

  for cube in all(active_cubes) do
    cube:draw""
  end
end