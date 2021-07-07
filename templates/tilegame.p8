pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--game

function _init()
  b = board:new(9,12)
  b:add(1,1,1)
  b:add(2,2,18)
  b:add(5,4,17)
end

function _update()

end

function _draw()
  cls()
  b:draw(64,64)
end

-->8
--board

board={
  __tostring=function(self) return "<board:"..self.width..":"..self.height..">" end
}

function board:new(w,h)
  local b={}
  setmetatable(b, board)
  --constructor
  b.width = w
  b.height = h
  b.tiles = {}
  b.twidth = 8
  b.theight = 8

  b.bgtile = 5
  b.bgsel = 6

  --methods
  b.get = board_get
  b.add = board_add
  b.remove = board_remove
  b.clear = board_clear
  b.draw = board_draw
  b.hash = board_hash
  b.unhash = board_unhash

  --end class
  return b
end

function board_hash(self,x,y) 
  return (self.width*(y-1))+x-1
end

function board_unhash(self,val) 
  local dx,dy = val%(self.width-1), val\(self.height-1)
  return dx+1, dy+1
end

function board_get(self,x,y)
  return self.tiles[self:hash(x,y)]
end

function board_add(self,x,y,v)
  self.tiles[self:hash(x,y)] = v
end

function board_remove(self,x,y)
  deli(self.tiles, self:hash(x,y))
end

function board_clear(self)
  self.tiles = {}
end

function board_draw(self, cx, cy)
  local w,h = self.width*self.twidth, self.height*self.theight
  local x,y = cx-w/2, cy-h/2
  --draw bg tiles
  for j=1,self.height do
    x=cx-w/2
    for i=1,self.width do
      spr(self.bgtile,
      x,
      y,
      self.twidth/8,
      self.theight/8)
      x+=self.twidth
    end
    y+=self.theight
  end
  x,y = cx-w/2, cy-h/2
  --draw tiles
  for k,v in pairs(self.tiles) do
    local dx,dy = self:unhash(k)
    print(k..":"..dx..":"..dy)
    spr(v,
    x+(dx-1)*self.twidth,
    y+(dy-1)*self.theight,
    self.twidth/8,
    self.theight/8)
  end
end

__gfx__
00000000066666600666666006666660066666601111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d663b666d668e666d661c666d669a6661000000100000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700d663b666d668e666d661c666d669a6661000000100000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000d6333b66d6888e66d6111c66d6999a661000000100000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000d6333b66d6888e66d6111c66d6999a661000000100000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700d33333b6d88888e6d11111c6d99999a61000000100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d33333b6d88888e6d11111c6d99999a61000000100000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dddddd00dddddd00dddddd00dddddd01111111100000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000066666600666666006666660066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d66bb666d66ee666d66cc666d66aa6660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d6333b66d6888e66d6111c66d6999a660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d33333b6d88888e6d11111c6d99999a60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d33333b6d88888e6d11111c6d99999a60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d6333366d6888866d6111166d69999660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d6633666d6688666d6611666d66996660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dddddd00dddddd00dddddd00dddddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000066666600666666006666660066666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d6666666d6666666d6666666d66666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d633bb66d688ee66d611cc66d699aa660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d6333b66d6888e66d6111c66d6999a660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d6333366d6888866d6111166d69999660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d6333366d6888866d6111166d69999660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d6666666d6666666d6666666d66666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dddddd00dddddd00dddddd00dddddd00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000