pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function _init()
	p=player:new(64,64)
end

function _update()
	p:update()
end

function _draw()
	cls(1)
	map(0,0,0,0)
	p:draw()
end
-->8
--player

player={
	__tostring=function(self)
		return "<player>"
	end
}

function player:new(x,y)
	local p={}
	setmetatable(p,player)
	--constructor
	p.pos=vector:new(x,y)
	p.maxspeed=1.5
	
	--sprites
	p.width=1
	p.height=1
	p.anims={
		idle={
			ticks=1,
			frames={1}
		},
		walk={
			ticks=5,
			frames={1,2}
		}
	}
	p.curanim="idle"
	p.curframe=1
	p.animtick=0
	p.flipx=false
	
	
	--methods
	p.draw=player_draw
	p.update=player_update
	
	function p:anim()
		return self.anims[self.curanim]
	end
	--end class
	return p
end

function player_draw(self)
	local a=self:anim()
	if self.curframe < 1 then
		print(self.curframe)
	end
	spr(a.frames[self.curframe],
	self.pos.x-(self.width*4),
	self.pos.y-(self.height*4),
	self.width,
	self.height,
	self.flipx,
	false)
end

function player_update(self)
	local bl=btn(⬅️) and -1 or 0
	local br=btn(➡️) and 1 or 0
	local bu=btn(⬆️) and -1 or 0
	local bd=btn(⬇️) and 1 or 0
	
	--calc movement
	local delta=vector:new(bl+br,bu+bd)
	delta=delta:norm()*self.maxspeed

	--calc collusion
	
	--update pos
	self.pos += delta
	
	--set anim
	if #delta == 0 then
		self.curanim = "idle"
		self.curframe = 1
	else
		self.curanim = "walk"
	end
	
	if delta.x!=0 then
		self.flipx=delta.x<0
	end
	
	--update anim
	local a = self:anim()
	self.animtick-=1
	if self.animtick <= 0 then
		self.curframe+=1
		if self.curframe > #a.frames then
			self.curframe=1
		end
		self.animtick=a.ticks
	end
end
-->8
--utils

--constants
inf =  32767

darkenshademap = {
		"0,0,0,0,0,0",
		"1,1,1,0,0,0",
		"2,2,1,1,0,0",
		"3,3,3,1,1,0",
		"4,2,2,1,1,0",
		"5,5,1,1,1,0",
		"6,6,13,5,1,0",
		"7,7,6,13,1,0",
		"8,8,2,2,1,0",
		"9,4,2,2,1,0",
		"10,9,4,2,1,0",
		"11,11,3,3,1,0",
		"12,12,13,5,1,0",
		"13,13,5,1,1,0",
		"14,14,4,2,1,0",
		"15,9,4,2,1,0",
	}

--utils
function round(v)
  return flr(v+0.5)
end

function darken(c,v)
	return tonum(split(darkenshademap[c+1])[v])
end

function join(a,b)
  local t = {}
  for v in all(a) do
    add(t,v)
  end
  for v in all(b) do
    add(t,v)
  end
  return t
end


-->8
--math

--vectors
vector = {
  __tostring = function(self)
		return "<"..self.x..":"..self.y..":"..self.z..">"
  end,
  __add = function(self, other)
    local v = vector:new()
    v.x = self.x + other.x
    v.y = self.y + other.y
    v.z = self.z + other.z
    return v
  end,
  __sub = function(self, other)
    local v = vector:new()
    v.x = self.x - other.x
    v.y = self.y - other.y
    v.z = self.z - other.z
    return v
  end,
  __mul = function(self, other)
    local v = vector:new()
    v.x = self.x * other
    v.y = self.y * other
    v.z = self.z * other
    return v
  end,
  __div = function(self, other)
    local v = vector:new()
    v.x = self.x / other
    v.y = self.y / other
    v.z = self.z / other
    return v
  end,
  __len = function(self)
    return sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
  end
}

function vector:new(x, y, z)
  --constructor
  local v = {}
  setmetatable(v, vector)
  v.x = x or 0
  v.y = y or 0
  v.z = z or 0

  --methods
  function v:copy()
    return vector:new(self.x, self.y, self.z)
  end

  function v:dot(other)
	  return (self.x * other.x) + (self.y * other.y) + (self.z * other.z)
  end

  function v:cross(other)
    local v = vector:new()
    v.x = (self.y * other.z) - (self.z * other.y)
    v.y = (self.z * other.x) - (self.x * other.z)
    v.z = (self.x * other.y) - (self.y * other.x)
    return v
  end

  function v:norm()
  	if #self==0 then 
  		return self:copy()
   end
   return self/#self
  end

  return v
end
__gfx__
00000000000000000009900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000990000099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700009999000099190000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000099190000f9990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000f999000f99990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000f999000099999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000900009000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009009000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c000000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0cc660d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0660d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c00d0d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0cddd0d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c000000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000001000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000101000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000001000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010100000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000010101010000010101010001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000010000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000010000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
