pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
---------------------------------------
--particles
---------------------------------------

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

-->8
--sample
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

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
