pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function new_board(w, h)
  board = {}
  for y=1,h do
    board[y] = {}
    for x=1,w do
      board[y][x] = false --new_block(x, y)
    end
  end

  boardx1 = 64 - (w * 4)
  boardy1 = 64 - (h * 4)
  boardx2 = boardx1 + (w * 8)
  boardy2 = boardy1 + (h * 8)
end

function draw_board()
  --background
  rectfill(boardx1,boardy1,boardx2,boardy2,indigo)
  rect(boardx1 - 1,boardy1 - 1,boardx2,boardy2,brown)

  --blocks
  for y,row in pairs(board) do
    for x,cell in pairs(row) do
      if (cell ~= false) then
        _x = boardx1 + ((x - 1) * 8)
        _y = boardy1 + ((y - 1) * 8)
        block_draw(cell, _x, _y)
      end
    end
  end
end

function board_add(cell)
  board[cell.y][cell.x] = cell
end