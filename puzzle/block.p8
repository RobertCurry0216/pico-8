pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

--Constructor
function new_block()
  return {
    sprite=1,
    color=orange,
    sec_color=yellow
  }
  
end

--block methods

--block functions
function block_draw(self, x, y)
  pal(13,self.color)
  pal(14,self.sec_color)
  spr(self.sprite,x,y)
  pal()
end