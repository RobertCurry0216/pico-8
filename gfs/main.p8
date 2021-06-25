pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--componants
#include math/math.p8

#include raster/engine.p8

function _init()
	c = camera:new()
	vertexes = {
		vector:new(-1, 1, 1),
		vector:new(-1, -1, 1),
		vector:new(1, -1, 1),
		vector:new(1, 1, -1),
		vector:new(-1, 1, -1),
		vector:new(-1, -1, -1),
		vector:new(1, -1, -1),
		vector:new(1, 1, 1)
	}

	triangles = {
		triangle:new(8, 1, 2, 8),
		triangle:new(8, 2, 3, 8),
		triangle:new(4, 8, 3, 3),
		triangle:new(4, 3, 7, 3),
		triangle:new(5, 4, 7, 12),
		triangle:new(5, 7, 6, 12),
		triangle:new(1, 5, 6, 10),
		triangle:new(1, 6, 2, 10),
		triangle:new(4, 5, 1, 14),
		triangle:new(4, 1, 8, 14),
		triangle:new(2, 6, 7, 15),
		triangle:new(2, 7, 3, 15)
	}

	cube = model:new(vertexes, triangles, "cube")
	cube1 = instance:new(
		cube, 
		vector:new(2,2,14)
	)
	cube2 = instance:new(
		cube, 
		vector:new(2,2,14)
	)
	cube1.wireframe = true
	scene = {cube1, cube2}

	p1=vector:new(rnd(128),rnd(128))
	p2=vector:new(rnd(128),rnd(128))
	p3=vector:new(rnd(128),rnd(128))
	p1.delta=vector:new(rnd(2)-1,rnd(2)-1)
	p2.delta=vector:new(rnd(2)-1,rnd(2)-1)
	p3.delta=vector:new(rnd(2)-1,rnd(2)-1)
end

function _update()
	cube1.transform.translation.x = sin(time()/5)*5
	cube1.transform.translation.y = cos(time()/5)*5
	cube2.transform.translation.x = sin(time()/5)*-5
	cube2.transform.translation.y = cos(time()/5)*-5

	for p in all({p1,p2,p3}) do
		v_update(p, p.delta)
		if p.x < 0 or p.x > 128 then p.delta.x *= -1 end
		if p.y < 0 or p.y > 128 then p.delta.y *= -1 end
	end
end

function _draw()
	cls(1)
	trifill(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,2)
	c:render(scene)
	color()
	print("cpu:"..stat(1))
	print("fps:"..stat(7))
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
