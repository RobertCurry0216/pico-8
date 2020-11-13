pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--Constructor
function new_block(x, y)
  return {
    x = x, 
    dx = 0,
    y = y,
    dy = 0,
    sprite=1,
    color=orange,
    sec_color=yellow
  }
end

--block methods
function block_draw(self, x, y)
  pal(13,self.color)
  pal(14,self.sec_color)

  self.dx *= 0.8
  if (self.dx < 1 and self.dx > -1) self.dx = 0

  self.dy *= 0.8
  if (self.dy < 1 and self.dy > -1) self.dy = 0

  spr(self.sprite, x + self.dx, y + self.dy)
  pal()
end

function block_move(self, dx, dy)
  if (self.x + dx > 0 and self.x + dx <= #board[1] and self.y + dy > 0 and self.y + dy <= #board) then
    board[self.y][self.x] = false
    self.x += dx
    self.y += dy
    self.dx += 8 * dx * -1
    self.dy += 8 * dy * -1
    board[self.y][self.x] = self
  end
end
