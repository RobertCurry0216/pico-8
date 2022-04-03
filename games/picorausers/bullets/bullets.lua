bullets = {}
enemy_bullets = {}

function bullets_update(store)
	for i=#store,1,-1 do
		local b = store[i]
		b:update()

		if b.dead then
			deli(store, i)
		end
	end
end

function bullets_draw(store)
	for b in all(store) do
		b:draw()
    if b.pos.x < 128 then
      b.pos.x+=width
      b:draw()
      b.pos.x-=width
    elseif width - b.pos.x < 128 then
      b.pos.x-=width
      b:draw()
      b.pos.x+=width
    end
	end
end

function bullets_collisions(store, others)
	for b in all(store) do
		for e in all(others) do
			if b.area:overlaps(e.area) then
				e:on_hit(b.damage)
				b:die()
			end
		end
	end
end