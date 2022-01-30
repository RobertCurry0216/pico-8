pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
--main
#include debug.lua 

function _init()
	--never repeat button presses
	poke(0X5F5C, 255)
	p=player:new(64,64)
	cam={x=0, y=0}
end

function _update()
	--handle inputs
	inputs = {
		left=btn(⬅️),
		right=btn(➡️),
		up=btn(⬆️),
		down=btn(⬇️),
		x=btn(X),
		o=btn(O),
		left_p=btnp(⬅️),
		right_p=btnp(➡️),
		up_p=btnp(⬆️),
		down_p=btnp(⬇️),
		x_p=btnp(X),
		o_p=btnp(O),
	}

	p:update()
	particles:update()
end

function _draw()
	cls(1)
	camera(p.pos.x-64, 0)
	map()
	p:draw()
	particles:draw()

	-- debugging
	debug.state = p:state()
	debug.cpu = stat(1)
	camera()
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

function xor(a, b)
	return a != b
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
	local x1=((x+dx)/8)
	local x2=((x+dx+(w/2))/8)
	local x3=((x+dx+w-1)/8)
	local y1=((y+dy)/8)
	local y2=((y+dy+(h/2))/8)
	local y3=((y+dy+h-1)/8)

	return (
		fget(mget(x1,y1)) |
		fget(mget(x2,y1)) |
		fget(mget(x3,y1)) |
		fget(mget(x1,y2)) |
		fget(mget(x3,y2)) |
		fget(mget(x1,y3)) |
		fget(mget(x2,y3)) |
		fget(mget(x3,y3)))&f == f
end

function plr_collide_map(plr, dx, dy)
	return collide_map(plr.pos.x,plr.pos.y,plr.width,plr.height,nil,dx,dy) 
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

function edge_bump_vert(plr, dy)
	local dx = plr.pos.x - (round(plr.pos.x / 8) * 8)
	if not plr_collide_map(plr,-dx,dy) then
		plr.pos.x -= dx
	end
end

function edge_bump_horiz(plr, dy)
	local dx = plr.pos.x - (round(plr.pos.x / 8) * 8)
	if not plr_collide_map(plr,-dx,dy) then
		plr.pos.x -= dx
	end
end

function bump_out(plr)
	if plr_collide_map(plr, 0, 0) then
		edge_bump_vert(plr, 0, 0)
		edge_bump_horiz(plr, 0, 0)
	end
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
		posx = round(posx)
		delta = get_collisions_x(posx, posy, delta, plr.width, plr.height)
	end
	
	--update pos
	plr.pos.x = posx + delta

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
		posy = round(posy)
		delta = get_collisions_y(plr.pos.x, posy, delta, plr.width, plr.height)
	end
	
	--update pos
	plr.pos.y = posy + delta
	return delta
end

--player states

-- run state
run_state = state:new "run"
run_state.maxspeed = 2
run_state.sprite = {ticks=5, frames={1,2}}

function run_state:update(plr)
	--calc movement
	move_player_x(plr, get_dx() *self.maxspeed)

	if not plr:collide_under() then
		plr:goto_state("fall", nil, true)
		return
	end

	if inputs.up_p then
		plr:goto_state "jump"
	end

	if not xor(inputs.left, inputs.right) then
		plr:goto_state "idle"
		return
	end
end

-- idle state
idle_state = state:new "idle"
idle_state.sprite = {ticks=1,frames={1}}

function idle_state:on_enter(plr)
	bump_out(plr)
end

function idle_state:update(plr)
	if not plr:collide_under() then
		plr:goto_state("fall", nil, true)
		return
	end

	if inputs.up_p then
		plr:goto_state "jump"
	end

	if xor(inputs.left, inputs.right) then
		plr:goto_state "run"
		return
	end
end


-- fall state
fall_state = state:new "fall"
fall_state.sprite = {ticks=1, frames={6}}
fall_state.maxfallspeed = 2.5
fall_state.maxspeed = 2
fall_state.grav = 0.2
fall_state.coyote = 5

function fall_state:on_enter(plr, initial_speed, coyote)
	self.fallspeed = initial_speed or 0
	self.coyote_time = coyote and self.coyote or 0
	self.jump_buffer = 0
end

function fall_state:update(plr)
	self.coyote_time -= 1
	self.fallspeed = min(self.fallspeed+self.grav, self.maxfallspeed)
	local delta = move_player_y(plr, self.fallspeed)
	move_player_x(plr, get_dx()*self.maxspeed)

	self.jump_buffer -= 1
	if inputs.up_p then
		self.jump_buffer = 5
	end

	if plr:collide_under() then
		if self.jump_buffer > 0 then
			plr:goto_state "jump"
		else
			plr:goto_state "idle"
		end
	end

	if self.coyote_time > 0 and inputs.up_p then
		plr:goto_state "jump"
	end
end


-- jump state
jump_state = state:new "jump"
jump_state.sprite = {ticks=4, frames={3,4,5,6}}
jump_state.speed = 2
jump_state.lift = -4
jump_state.max_time = 6
jump_state.min_time = 3

function jump_state:on_enter()
	self.time = 0
end

function jump_state:update(plr)
	if plr:collide_over() then
		edge_bump_vert(plr, self.lift)
	end
	local dy = move_player_y(plr, self.lift)
	move_player_x(plr, get_dx()*self.speed)
	self.time += 1

	if (self.time >= self.min_time and not inputs.up)
	or dy == 0
	or self.time >= self.max_time
	then
		plr:goto_state("fall", -1, false)
	end
end

--player helpers

function get_dx()
	return (inputs.right and 1 or 0) - (inputs.left and 1 or 0)
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
		self.sm.state:update(self)
		
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

		particles:spawn("dot", self.pos.x+4, self.pos.y+4)
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

	function p:collide_under()
		return collide_map(self.pos.x,self.pos.y,self.width,self.height,nil,0,1)
	end

	function p:collide_over()
		return collide_map(self.pos.x,self.pos.y,self.width,self.height,nil,0,-1)
	end

	--end class
	return p
end

-->8
--math

--vectors
vector = {
  __tostring = function(self)
		return "<"..self.x..":"..self.y..">"
  end,
  __add = function(self, other)
    return vector:new(
    	self.x + other.x,
    	self.y + other.y
		)
  end,
  __sub = function(self, other)
    return vector:new(
    	self.x - other.x,
    	self.y - other.y
		)
  end,
  __mul = function(self, other)
    return vector:new(
    	self.x * other,
    	self.y * other
		)
  end,
  __div = function(self, other)
    return vector:new(
    	self.x / other,
    	self.y / other
		)
  end,
  __len = function(self)
    return sqrt(self.x*self.x + self.y*self.y)
  end
}

function vector:new(x, y)
  --constructor
  local v = {}
  setmetatable(v, vector)
  v.x = x or 0
  v.y = y or 0

  --methods
  function v:copy()
    return vector:new(self.x, self.y)
  end

  function v:dot(other)
	  return self.x*other.x + self.y*other.y
  end

  function v:cross(other)
    return self.x*other.y - self.y*other.x
  end

  function v:norm()
		local l = #self
  	if l==0 then 
  		return self:copy()
   end
   return self/l
  end

  return v
end


-->8
--particles

particles = {}

function particles:add_type(handler)
	self[handler.name] = handler
end

function particles:spawn(name, ...)
	local p = self[name].spawn(...)
	add(self, p)
end

function particles:update()
	for i=#self,1,-1 do
		local p = self[i]
		self[p.name].update(p)

		if p.life <= 0 then
			deli(self, i)
		end
	end
end

function particles:draw()
	for p in all(self) do
		self[p.name].draw(p)
	end
end

--dot particle
particles:add_type({
	name="dot",
	spawn=function(x,y)
		return {name="dot", x=x, y=y, life=20}
	end,

	update=function(p)
		p.life -= 1
	end,

	draw=function(p)
		pset(p.x, p.y, 7)
	end
})



__gfx__
00000000000000000009900000000000900000000000000900000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000990000099990000000000099900000999009000099000000000000000000000000000000000000000000000000000000000000000000000000000
00700700009999000099190000099900099f90000991909000999900000000000000000000000000000000000000000000000000000000000000000000000000
000770000099190000f999000099999099f9900009f999900f991900000000000000000000000000000000000000000000000000000000000000000000000000
0007700000f999000f99990009f9199000919900099f999900f99900000000000000000000000000000000000000000000000000000000000000000000000000
0070070000f9990000999990099f9900009999000099990000999990000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000900009009990000000990000000000000999009000000000000000000000000000000000000000000000000000000000000000000000000
00000000009009000000000090090000000000000000000000000900000000000000000000000000000000000000000000000000000000000000000000000000
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
1000000000000000000000001000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010101010101010101010101010100010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000010101010101010000000000000000000000010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010101010100000000000001010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000101000000000100000000000101010000000000000000000101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000001000000000000000000000001010101010100000000010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010100000000000000000001010000000000000001010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000101010101010100000101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000100000000000001010000000000010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000101000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000010101010101010100000101010101010101010101010101010000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000010000000000000000000000000000000000010000000000010000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000010000000000000000000000000000010000000000010000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
