pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--main
#include debug.lua 

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
	camera(0,0)
	p:draw()
	debug.state = p:state()
	debug.cpu = stat(1)
  draw_debug()
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

function sign(v)
	return round(v/abs(v))
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
function collide_map(x,y,w,h,f,dx,dy)
	w=w or 8
	h=h or 8
	f=f or 1
	dx=dx or 0
	dy=dy or 0
	local x1=((x+dx)/8)+cam.x
	local x2=((x+dx+(w/2))/8)+cam.x
	local x3=((x+dx+w-1)/8)+cam.x
	local y1=((y+dy)/8)+cam.y
	local y2=((y+dy+(h/2))/8)+cam.y
	local y3=((y+dy+h-1)/8)+cam.y

	local c_tl=fget(mget(x1,y1))
	local c_tm=fget(mget(x2,y1))
	local c_tr=fget(mget(x3,y1))

	local c_ml=fget(mget(x1,y2))
	local c_mr=fget(mget(x3,y2))

	local c_bl=fget(mget(x1,y3))
	local c_bm=fget(mget(x2,y3))
	local c_br=fget(mget(x3,y3))

	return (c_tl | c_tm | c_tr | c_ml | c_mr | c_bl | c_bm | c_br)&f == f
end

function get_collisions_x(x,y,dx,w,h,f)
	local delta=0
	local signx = sign(dx)
	x=round(x)
	dx = round(dx)

	for d = 0,dx,signx do
		if collide_map(x+d,y,w,h,f) then
			break
		end
		delta = d
	end
	return delta
end

function get_collisions_y(x,y,dy,w,h,f)
	local delta=0
	local signy = sign(dy)
	y=round(y)
	dy = round(dy)

	for d = 0,dy,signy do
		if collide_map(x,y+d,w,h,f) then
			break
		end
		delta = d
	end
 return	delta
end

--state machine
statemachine = {}

function statemachine:new()
	local sm = {
		-- properties
		states = {},

		-- methods
		update = function(self, ...)
			self.state:update(...)
		end,

		draw = function(self, ...)
			self.state:draw(...)
		end,

		goto_state = function(self, name, ...)
			self.state:on_exit(...)
			self.state = self.states[name]
			self.state:on_enter(...)
		end,

		add_state = function(self, state)
			self.states[state.name] = state
		end,
	}
	setmetatable(sm, statemachine)
	return sm
end

-- states
state = {
	__tostring=function(self)
		return "<state: "..self.name..">"
	end
}
function state:new(name)
	local s = {
		name = name,
		on_enter = function() end,
		on_exit = function() end,
		update = function() end,
		draw = function() end
	}
	setmetatable(s, state)
	return s
end

-->8
--player helpers

function move_player_x(plr, delta)
	--calc collusion
	local posx, posy = plr.pos.x, plr.pos.y
	local collision = collide_map(posx,posy,plr.width,plr.height,nil,delta)
	if collision then
		delta = get_collisions_x(posx, posy, delta, plr.width, plr.height)
	end
	
	--update pos
	plr.pos.x += delta

	--flip x
	if delta != 0 then
		plr.flipx = delta < 0
	end

	return delta
end

function move_player_y(plr, delta)
	--calc collusion
	local posx, posy = plr.pos.x, plr.pos.y
	local collision = collide_map(posx,posy,plr.width,plr.height,nil,nil,delta)
	if collision then
		delta = get_collisions_y(posx, posy, delta, plr.width, plr.height)
	end
	
	--update pos
	plr.pos.y += delta
	return delta
end

--player states

run_state = state:new("run")
run_state.maxspeed = 1.5
run_state.sprite = {ticks=5, frames={1,2}}

function run_state:update(plr, inputs)
	--calc movement
	move_player_x(plr, (inputs.right-inputs.left) *self.maxspeed)

	if not plr:is_on_ground() then
		plr:goto_state "fall"
		return
	end

	if inputs.up > 0 then
		plr:goto_state "jump"
	end

	if inputs.left - inputs.right == 0 then
		plr:goto_state "idle"
		return
	end
end

idle_state = state:new("idle")
idle_state.sprite = {ticks=1,frames={1}}

function idle_state:update(plr, inputs)
	if not plr:is_on_ground() then
		plr:goto_state "fall"
		return
	end

	if inputs.up > 0 then
		plr:goto_state "jump"
	end

	if inputs.left - inputs.right != 0 then
		plr:goto_state "run"
		return
	end
end

fall_state = state:new("fall")
fall_state.sprite = {ticks=1, frames={2}}
fall_state.maxfallspeed = 2
fall_state.maxspeed = 1.5
fall_state.grav = 0.15

function fall_state:on_enter()
	self.fallspeed = 0
end

function fall_state:update(plr, inputs)
	self.fallspeed += self.grav
	local delta = move_player_y(plr, self.fallspeed)
	move_player_x(plr, (inputs.right-inputs.left) *self.maxspeed)

	if plr:is_on_ground() or delta == 0 then
		plr:goto_state "idle"
	end
end

jump_state = state:new("jump")
jump_state.sprite = {ticks=1, frames={2}}
jump_state.speed = 1.5
jump_state.lift = -4
jump_state.max_time = 6
jump_state.min_time = 3

function jump_state:on_enter()
	self.time = 0
end

function jump_state:update(plr, inputs)
	local dy = move_player_y(plr, self.lift)
	move_player_x(plr, (inputs.right-inputs.left) *self.speed)
	self.time += 1
	if (dy == 0 and self.time >= self.min_time)
	or inputs.up != 1
	or self.time >= self.max_time
	then
		plr:goto_state "fall"
	end
end

--player class

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
	local sm=statemachine:new()
	sm:add_state(run_state)
	sm:add_state(idle_state)
	sm:add_state(fall_state)
	sm:add_state(jump_state)
	sm.state = idle_state
	p.sm = sm


	p.width=8 --pixel width
	p.height=8 --pixel height
	p.flipx=false
	
	p.curframe=1
	p.animtick=0
	
	--methods
	function p:draw()
		local a=self:sprite()
		if self.curframe < 1 then
			print(self.curframe)
		end
		spr(a.frames[self.curframe],
		self.pos.x,
		self.pos.y,
		self.width/8,
		self.height/8,
		self.flipx,
		false)

		self.sm:draw(self)
	end

	function p:update()
		local inputs = {
			left=btn(⬅️) and 1 or 0,
			right=btn(➡️) and 1 or 0,
			up=btn(⬆️) and 1 or 0,
			down=btn(⬇️) and 1 or 0,
			x=btn(X),
			o=btn(O)
		}
		
		self.sm.state:update(self, inputs)
		
		--update anim
		local a = self:sprite()
		self.animtick-=1
		if self.animtick <= 0 then
			self.curframe+=1
			if self.curframe > #a.frames then
				self.curframe=1
			end
			self.animtick=a.ticks
		end
	end

	function p:state()
		return self.sm.state
	end
	
	function p:sprite()
		return self.sm.state.sprite
	end

	function p:goto_state(state, ...)
		self.curframe = 1
		self.animtick = 0
		self.sm:goto_state(state, self, ...)
	end

	function p:is_on_ground()
		return collide_map(self.pos.x,self.pos.y,self.width,self.height,nil,0,1)
	end

	--end class
	return p
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
1000000010101010101010101010001010001000000000000000000000100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000010000000000000000000001010001010101010101010101010100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000010000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
