pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--Constructor
function new_block()
  return {
    sprite=1,
    color=orange,
    sec_color=yellow,
    draw=block_draw
  }
end

--block methods
function block_draw(self, x, y)
  pal(13,self.color)
  pal(14,self.sec_color)
  spr(self.sprite,x,y)
  pal()
end

--block functions
function new_location(x, y)
	return {
		x=x,
		y=y,
		drawx=function (self)
			return board_x + self.x * 8
		end,
		drawy=function (self)
			return board_y + self.y * 8
		end
	}
end