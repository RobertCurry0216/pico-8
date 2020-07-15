pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

--constructor
function new_blockgroup(w, h)
  return {
    blocks={},
    width=w,

    hight=h,
    size=w*h,
    push=blockgroup_push,
    get=blockgroup_get,
  }  
end

--methods
function blockgroup_push(self, block, x, y)
  self.blocks[x+(x*y)]=block
end

function blockgroup_get(self, x, y)
  return self.blocks[x+(x*y)]
end

function blockgroup_draw(self)
  
end

--functions

