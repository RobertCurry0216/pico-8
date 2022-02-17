pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
--main <=============================================

-- [x] state machine system
-- [x] basic collision detection
-- [x] basic platforming controls (moving/jumping)
-- [x] improve jumping
-- [x] coyote time
-- [x] edge bump
-- [x] sprite animation system
-- [x] particles
-- [x] pickups/coins
-- [x] enemies
-- [ ] hazzards/spikes
-- [ ] improve camera following
-- [ ] jump through platforms
-- [ ] wall jump
-- [ ] moving platforms
-- [ ] double jump
-- [ ] acceleration
-- [ ] pushable blocks


#include debug.lua 

function _init()
	--never repeat button presses
	poke(0X5f5c, 255)
	p=player(64,64)
  load_map_items()
	cam={x=0, y=0}
	
	register("coin_collected", add_coin)
end

function _update()
	--handle inputs
	inputs = {
		left=btn(⬅️),
		right=btn(➡️),
		-- up=btn(⬆️),
		-- down=btn(⬇️),
		-- x=btn(❎),
		-- o=btn(🅾️),
		-- left_p=btnp(⬅️),
		-- right_p=btnp(➡️),
		-- up_p=btnp(⬆️),
		-- down_p=btnp(⬇️),
		-- x_p=btnp(❎),
		-- o_p=btnp(🅾️),
		jump=(btn(⬆️) or btn(❎)),
		jump_p=(btnp(⬆️) or btnp(❎)),
	}

	p:update()
  map_items:update()
	particles:update()
	timer:update()
end

function _draw()
	cls()
	before_draw()

	rectfill(0,0,127,127,1)
	cam = {x=p.pos.x-64, y=0}
	camera(cam.x, cam.y)
	map()
	p:draw()
  map_items:draw()
	particles:draw()

	after_draw()

	draw_ui()

	--debugging
	--debug.state = p:state()
	draw_debug()
end

-->8
--class <=============================================
class={
	extend = function (self, subtype)
	subtype = subtype or {}
  subtype.super = self
 	local meta={__index=subtype}
 	return setmetatable(subtype,{
  	__index = self,
  	__call=function(self, ...)
 		 local instance=setmetatable({},meta)
  	 return instance,instance:new(...)
   end
  })
 end,
 new = function() end,
}

--sprite helpers <=============================================
function sprite(t, ...)
  return {ticks=t, frames={...}}
end

function draw_sprite(s, x, y, w, h, f)
	--draw
  spr(s.sprite.frames[s.curframe],x,y,w or 1,h or 1,f or false)
	--tick
	s.animticks-=1
  if s.animticks <= 0 then
    s.curframe += 1
    if s.curframe > #s.sprite.frames then
      s.curframe = 1
    end
    s.animticks =  s.sprite.ticks
  end
end

--constants <=============================================
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

--utils <=============================================
function _nothing_() end

function round(v)
  return flr(v+0.5)
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

--mapping helpers <=============================================
map_items = {}

function map_items:update()
  for i=#self,1,-1 do
    self[i]:update()
    if self[i].dead then
      deli(self, i)
    end
  end
end

function map_items:draw()
  for pu in all(self) do
    pu:draw()
  end
end

function load_map_items()
	local map_item_key = {
		[17]=coin,
		[32]=buzzsaw
	}
	for x=1,128 do
		for y=1,32 do
			local f = map_item_key[mget(x,y)]
			if f then
				add(map_items, f(x*8, y*8))
				mset(x,y,0)
			end
		end
	end
end

--collision helpers <=============================================
function aabb(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2
  and x2 < x1+w1
  and y1 < y2+h2
  and y2 < y1+h1
end

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

function collide_plr(obj)
  return aabb(
    obj.pos.x,obj.pos.y,obj.width,obj.height,
    p.pos.x,p.pos.y,p.width,p.height
  )
end

--collider class <=============================================
collider=class:extend({width=8, height=8})
function collider:new(actor)
  self.actor = actor
end

function collider:collide_map(dx, dy, f)
  local pos = self.actor.pos
  return collide_map(pos.x, pos.y, self.width, self.height, f, dx, dy)
end

function collider:push_x(dx, f) --> new_x, delta
  local delta, signx = 0, sgn(dx)
  local x, y, w, h = self.actor.pos.x, self.actor.pos.y, self.width, self.height
	dx=round(dx)

	for d = 0,dx,signx do
		if collide_map(round(x)+d,y,w,h,f) then
			return round(x)+delta, delta
		end
		delta = d
	end
	return x+dx, dx
end

function collider:push_y(dy, f) --> new_y, delta
  local delta, signy = 0, sgn(dy)
  local x, y, w, h = self.actor.pos.x, self.actor.pos.y, self.width, self.height
	dy=round(dy)

	for d = 0,dy,signy do
		if collide_map(x,round(y)+d,w,h,f) then
			return round(y)+delta, delta
		end
		delta = d
	end
	return y+dy, dy
end

function collider:bump_x(dy)
  dy = dy or 0
  local dx = (round(self.actor.pos.x / 8) * 8) - self.actor.pos.x
	if not self:collide_map(dx,dy) then
		self.actor.pos.x += dx
	end
end

function collider:bump_y(dx)
  dx = dx or 0
  local dy = (round(self.actor.pos.y / 8) * 8) - self.actor.pos.y
	if not self:collide_map(dx,dy) then
		self.actor.pos.y += dy
	end
end

function collider:bump_out()
  if self:collide_map() then
    self:bump_x()
    self:bump_y()
  end
end

function collider:move_x(dx)
  local new_x = self.actor.pos.x + dx
	local col = self:collide_map(dx, 0)
	if col then
		new_x, dx = self:push_x(dx)
	end

	self.actor.pos.x = new_x
	return dx, col
end

function collider:move_y(dy)
  local new_y = self.actor.pos.y + dy
	local col = self:collide_map(0, dy)
	if col then
		new_y, dy = self:push_y(dy)
	end

	self.actor.pos.y = new_y

	return dy, col
end

--state machine <=============================================
statemachine = {}

function statemachine:new(...)
  local states = {...}
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
	}
	setmetatable(sm, statemachine)
  for s in all(states) do
    sm.states[s.name] = s
  end

  sm.state = states[1]
	return sm
end

state = {
	__tostring=function(self)
		return "<state: "..self.name..">"
	end,
  __index=function() return _nothing_ end
}
function state:new(name)
	return setmetatable({name = name}, state)
end

--signals <=============================================
signals = {}

function register(signal_name, callback)
  if not signals[signal_name] then signals[signal_name] = {} end
  add(signals[signal_name], callback)
end

function emit(signal_name, ...)
  if not signals[signal_name] then return end
  
  for i=1, #signals[signal_name] do
    signals[signal_name][i](...)
  end
end

function unregister(signal_name, callback)
  if not signals[signal_name] then return end

  for i=1, #signals[signal_name] do
    if signals[signal_name][i] == callback then deli(signals[signal_name], i) end
  end
end

function clear_signal(signal_name)
  signals[signal_name] = nil
end

--timer <=============================================
timer = {functions = {}}
setmetatable(timer, {__index=timer})

function update_timer_handle(handle)
		-- handle: {
		--   time = <number>,
		--   after = <function>,
		--   during = <function>,
		--   limit = <number>,
		--   count = <number>,
		-- }
		handle.time = handle.time + 1
		local dt = 1-((handle.limit - handle.time)/handle.limit)
		handle.during(max(dt, 0))

		while handle.time >= handle.limit and handle.count > 0 do
			if handle.after(handle.after) == false then
				handle.count = 0
				break
			end
			handle.time = handle.time - handle.limit
			handle.count = handle.count - 1
		end
end

function timer:update()
	-- timers may create new timers, which leads to undefined behavior
	-- in pairs() - so we need to put them in a different table first
	local to_update = {}
	for handle in pairs(self.functions) do
		to_update[handle] = handle
	end

	for handle in pairs(to_update) do
		if self.functions[handle] then
			update_timer_handle(handle)
			if handle.count == 0 then
				self.functions[handle] = nil
			end
		end
	end
end

function timer:during(delay, during, after)
	local handle = { time = 0, during = during, after = after or _nothing_, limit = delay, count = 1 }
	self.functions[handle] = true
	return handle
end

function timer:after(delay, func)
	return self:during(delay, _nothing_, func)
end

function timer:every(delay, after, count)
	local handle = { time = 0, during = _nothing_, after = after, limit = delay, count = count }
	self.functions[handle] = true
	return handle
end

function timer:cancel(handle)
	self.functions[handle] = nil
end

function timer:clear()
	self.functions = {}
end

function timer.new()
	return setmetatable({functions={}}, {__index=timer})
end

-->8
--ui <=============================================

score = 0

function draw_ui()
	camera()
	print("score: "..tostr(score), 4, 4, 7)
end

function add_coin()
	score += 1
end


--lights
--circle clipping v1
-- function before_draw()
-- 	circle = {x=p.pos.x+4-cam.x, y=p.pos.y+4, r=abs(sin(t()/10))*40}
-- 	clip(circle.x-circle.r, circle.y-circle.r, circle.r*2, circle.r*2)
-- end

-- function after_draw()
-- 	clip()
-- 	camera()

-- 	local y = flr(circle.y - circle.r) 
-- 	for i=1,flr(circle.r*2) do
-- 		local x = flr(i + circle.x - circle.r - 1)
-- 		local j = (i / circle.r) - 1
-- 		local y1 = (1-sqrt(1-j*j)) * circle.r
-- 		line(x, y, x, y+y1, 0)
-- 		line(x, y+(circle.r*2), x, y+(circle.r*2)-y1, 0)
-- 	end
-- end


--circle clipping v2
-- function before_draw()
-- 	circle = {x=p.pos.x+4-cam.x, y=p.pos.y+4, r=abs(sin(t()/10))*40}
-- end

-- function after_draw()
-- 	clip()
-- 	camera()

-- 	--remap the sprites to be the screen
-- 	poke(0x5f54, 0x60)

-- 	local cx1, cx2 = flr(circle.x-circle.r), flr(circle.x+circle.r)
-- 	local cy1, cy2 = flr(circle.y-circle.r), flr(circle.y+circle.r)

-- 	for i=0,15 do
-- 		pal(i, darken(i, 5))
-- 	end

-- 	--pal({0,1,1,2,0,5,5,2,5,13,3,1,1,2,13})

	
-- 	sspr(0,0,128,cy1,0,0)
-- 	sspr(0,cy2-1, 128, 127, 0, cy2-1)
-- 	sspr(0, cy1, cx1, cy2-cy1-1, 0, cy1)
-- 	sspr(cx2, cy1, 127, cy2-cy1-1, cx2, cy1)

-- 	for i=1,ceil(circle.r*2) do
-- 		local x = i + cx1 -1
-- 		local j = (i / circle.r) - 1
-- 		local d = (1-sqrt(1-j*j)) * circle.r
-- 		ssline(x, cy1, x, cy1+d)
-- 		ssline(x, cy2-d, x, cy2)
-- 	end

-- 	--reset
-- 	poke(0x5f54, 0)
-- 	pal()

-- end

-- function ssline(x1,y1,x2,y2)
-- 	sspr(x1, y1, 1, y2-y1, x1, y1)
-- end

-- circle clipping v3
function before_draw()
	circle = {x=p.pos.x+4-cam.x, y=p.pos.y+4, r=abs(sin(t()/10))*40}
end

function after_draw()
	clip()
	camera()

	local cx1, cx2 = flr(circle.x-circle.r), flr(circle.x+circle.r)
	local cy1, cy2 = flr(circle.y-circle.r), flr(circle.y+circle.r)

	--now drawing to sprite sheet
	poke(0x5f55, 0)
	cls(0)
	--draw clipping mask
	fillp(0b1010101010101010)
	circfill(circle.x, circle.y, circle.r+5, 7)
	fillp()
	circfill(circle.x, circle.y, circle.r, 7)
	--set white to transparent
	palt(7, true)
	palt(0, false)
	--draw full sprite sheet to screen
	poke(0x5f55, 0x60)
	sspr(0,0,128,128,0,0)

	--reset
	poke(0x5f54, 0)
	poke(0x5f55, 0x60)
	reload(0,0,0x2000)
	pal()
	palt()

end



-->8
--player states <=============================================

-- run state
run_state = state:new "run"
run_state.maxspeed = 2
run_state.sprite = {ticks=5, frames={1,2}}

function run_state:update(plr)
	--calc movement
	plr:move_x(get_dx()*self.maxspeed)

	if not plr:collide_map(0, 1) then
		plr:goto_state("fall", nil, true)
		return
	end

	if inputs.jump_p then
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
	plr:bump_out()
end

function idle_state:update(plr)
	if not plr:collide_map(0, 1) then
		plr:goto_state("fall", nil, true)
		return
	end

	if inputs.jump_p then
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
	local delta = plr:move_y(self.fallspeed)
	plr:move_x(get_dx()*self.maxspeed)

	self.jump_buffer -= 1
	if inputs.jump_p then
		self.jump_buffer = 5
	end

	if plr:collide_map(0,1) then
		if self.jump_buffer > 0 then
			plr:goto_state "jump"
		else
			plr:goto_state "idle"
		end
	end

	if self.coyote_time > 0 and inputs.jump_p then
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

function jump_state:on_enter(plr)
	self.time = 0
  self:update(plr)
end

function jump_state:update(plr)
	if plr:collide_map(0,-1) then
    plr:bump_x(self.lift)
	end
	local dy = plr:move_y(self.lift)
	plr:move_x(get_dx()*self.speed)
	self.time += 1

	if (self.time >= self.min_time and not inputs.jump)
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

--player class <=============================================

player=collider:extend({
	__tostring=function(self)
		return "<player>"
	end
})

function player:new(x,y)
  self.super.new(self, self)

	self.pos=vector:new(x,y)
	self.sm = statemachine:new(
    idle_state,
    run_state,
    fall_state,
    jump_state
  )

	self.flipx=false
	self.curframe=1
	self.animtick=0

	register("player_hurt", function(...) self:on_hurt(...) end)
end

--methods
function player:draw()
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

function player:update()
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

function player:state()
  return self.sm.state
end

function player:sprite()
  return self.sm.state.sprite
end

function player:goto_state(state, ...)
  self.curframe = 1
  self.animtick = 0
  self.sm:goto_state(state, self, ...)
end

function player:move_x(...)
  local dx = self.super.move_x(self, ...)
  if (dx != 0) self.flipx = dx < 0
  return dx
end

function player:on_hurt(damage)
	particles:spawn("sparkle", self.pos.x+4, self.pos.y+4)
end

-->8
--math <=============================================

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
--methods
function vector:copy()
  return vector:new(self.x, self.y)
end

function vector:dot(other)
  return self.x*other.x + self.y*other.y
end

function vector:cross(other)
  return self.x*other.y - self.y*other.x
end

function vector:norm()
  local l = #self
  if l==0 then 
    return self:copy()
  end
  return self/l
end

function vector:new(x, y)
  local v = {}
  setmetatable(v, vector)
  v.x = x or 0
  v.y = y or 0
  return v
end


-->8
--particles <=============================================

particles = {}

function particles:add_type(handler)
	self[handler.name] = handler
end

function particles:spawn(name, ...)
	self[name].spawn(self, ...)
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
	spawn=function(store, x,y)
		add(store, {name="dot", x=x, y=y, life=20})
	end,

	update=function(p)
		p.life -= 1
	end,

	draw=function(p)
		pset(p.x, p.y, 7)
	end
})

particles:add_type({
	name="line",
	spawn=function(store, x, y, dir)
		add(store, {name="line", pos=vector:new(x,y), dir=vector:new(cos(dir), sin(dir)), life=8})
	end,
	update=function(p)
		p.pos += p.dir
		p.life -= 1
	end,
	draw=function(p)
		local d = p.pos + (p.dir*3)
		line(p.pos.x, p.pos.y, d.x, d.y, 7)
	end
})

particles:add_type({
	name="sparkle",
	spawn=function(store,x,y)
		for i=1,6 do
			particles:spawn("line",x,y,i/6)
		end
	end
})

-->8
--pickups <=============================================
pickup = class:extend({width=8, height=8})

function pickup:new(x, y)
  self.pos = vector:new(x,y)
	self.curframe=1
	self.animticks=0
end

function pickup:update()
  if collide_plr(self) and not self.dead then
		self.dead = true
		self:destroy()
	end
end

function pickup:destroy() end

function pickup:draw()
  draw_sprite(self, self.pos.x, self.pos.y)
end

coin=pickup:extend({sprite=sprite(5,17,18,19,18,17)})
function coin:destroy()
	emit("coin_collected")
	particles:spawn("sparkle", self.pos.x+4, self.pos.y+4)
end


-->8
--enemies <=============================================
enemy = class:extend()

enemy_idle_state = state:new "idle"

function enemy:new(x,y)
	self.collider = collider(self)
  self.pos = vector:new(x,y)
  self.animticks = 0
  self.curframe = 1
	self.width = 8
	self.height = 8
end

function enemy:update()
  self.sm.state:update(self)
end

function enemy:draw()
  draw_sprite(self, self.pos.x, self.pos.y, 1, 1, self.flipx)
  self.sm.state:draw(self)
end

buzzsaw = enemy:extend()

function buzzsaw:new(...)
	self.super.new(self, ...)
  self.sm = statemachine:new(buzzsaw_move_state)
  self.sprite = sprite(2,32,33)
	self.speed = 1
end

buzzsaw_move_state = state:new "move"

function buzzsaw_move_state:update(obj)
	local _, c = obj.collider:move_x(obj.speed)
	if (c) obj.speed *= -1
	if (collide_plr(obj)) emit("player_hurt", 1)
end


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
c0cc660d000882000000800000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c0660d008a88200008a80000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c00d0d008888200008880000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0cddd0d000882000000800000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c000000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06006000006006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666606006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06cccc6066cccc660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66cd5c6006cd5c600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06c55c6606c55c600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06cccc6066cccc660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60666600006666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060060006006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011111111111111111111111011111111111111112011111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011111111111111111111111111111010101010101010101010101010101110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011111111111111111111111111111010111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011111111201111111110101010101010111111111111111111111110101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011111111111111111111111111111010101010101111111111111010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011101011111111101111111111101010111111111111111111101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011111011111111111111111111111010101010101111111110101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101111111111111111111010111111111111111010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011111111111111111111111111101010101010101111101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1020111111111111101111111111111010111111111110101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011111111111120101011111111111010111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011111110101010101010101111101010101010101010101010101010111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011111110111111111111111111111111111111111110111111111110111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1011111110111111111111112011111111111110111111111110111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
