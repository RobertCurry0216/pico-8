pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
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
-->8
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
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
