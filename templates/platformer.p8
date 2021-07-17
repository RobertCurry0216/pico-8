pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--main
function _init()
	p=player:new(64,64)
	cam={x=0, y=0}
end

function _update()
	p:update()
end

function _draw()
	cls(1)
	map(cam.x,cam.y,0,0)
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
  p.maxfallspeed=2
  p.acc=0.05
  p.dcc=0.8
  p.airdcc=1
  p.grav=0.15
	
	--sprites
	p.width=8 --pixel width
	p.height=8 --pixel height
	p.anims={
		idle={
			ticks=1,
			frames={1}
		},
		walk={
			ticks=5,
			frames={1,2}
		},
    jump={
      ticks=1,
      frames={2}
    },
    slide={
      ticks=1,
      frames={1}
    }
	}
	p.curanim="idle"
	p.curframe=1
	p.animtick=0
	p.flipx=false
	
  --jump controller
  p.jump={
    is_pressed=false, --pressed this frame
    is_held=false, --held btn down
    ticks_held=0,
    is_released=true,
    min_press=5,
    max_press=15,
    --update
    update=player_jump_update
  }

  p.grounded=false
  p.airtime=0
	
	--methods
	p.draw=player_draw
	p.update=player_update
	
	function p:anim()
		return self.anims[self.curanim]
	end

  function p:set_anim(anim)
    if(anim==self.curanim) return--early out.
    local a=self.anims[anim]
    self.animtick=a.ticks--ticks count down.
    self.curanim=anim
    self.curframe=1
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
	self.pos.x-(self.width/2),
	self.pos.y-(self.height/2),
	self.width/8,
	self.height/8,
	self.flipx,
	false)
end

function player_update(self)
	local bl=btn(⬅️) and 1 or 0
	local br=btn(➡️) and 1 or 0
	local bu=btn(⬆️) and 1 or 0
	local bd=btn(⬇️) and 1 or 0
	
	--calc movement
	local delta=vector:new(br-bl,bd-bu)
	delta=delta:norm()*self.maxspeed

	--calc collusion
	if collide_map(self.pos+delta,self.width,self.height) then
		local v=vector:new()
		local dx=vector:new(delta.x/self.width/2,0)
		local dy=vector:new(0,delta.y/self.height/2)
		while (not collide_map(self.pos+v+dx,self.width,self.height) and abs(v.x)<abs(delta.x-dx.x)) do
			v+=dx
		end
		while (not collide_map(self.pos+v+dy,self.width,self.height) and abs(v.y)<abs(delta.y-dy.y)) do
			v+=dy
		end
		delta = v
	end
	
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

function player_jump_update(self, pressed)
  self.is_pressed=false
  if pressed then
    if not self.is_held then
      self.is_pressed=true
    end
    self.is_held=true
    self.ticks_down+=1
  else
    self.is_held=false
    self.ticks_down=0
  end
end
-->8
--util

--constants
inf = 32767

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

--collision helpers
function collide_map(pos,w,h,f,dx,dy)
	w=w and w/2 or 4
	h=h and h/2 or 4
	f=f or 1
	dx=dx or 0
	dy=dy or 0
	local x1=((pos.x+w+dx-1)/8)+cam.x
	local x2=((pos.x-w-dx)/8)+cam.x
	local y1=((pos.y+h+dy-1)/8)+cam.y
	local y2=((pos.y-h-dy)/8)+cam.y

	local c_br=fget(mget(x1,y1))
	local c_tr=fget(mget(x1,y2))
	local c_bl=fget(mget(x2,y1))
	local c_tl=fget(mget(x2,y2))

	return (c_bl | c_br | c_tl | c_tr)&f == f
end

-->8
--math

function sign(x)
	return x/abs(x)
end

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
1010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000001000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010101010101010101010101010100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000010101010101010001010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010001000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000101000000000000000000000001010001000101010101010101000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000001000000000000000000000001010001000100000000000001000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010100000000000000000001010001000100000000000001000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010001000100000000000001000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010001000100000000000001000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010001000100000000000001000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000010101010000010101010001010001000000000000000000000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000010000000000000000000001010001010101010101010101010100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000010000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
