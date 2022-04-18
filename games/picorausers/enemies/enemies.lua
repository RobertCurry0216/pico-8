enemies = {}
enemy_grid = sp_grid(width, height, 20)

function enemies_update(self, plr)
	enemy_grid:clear()
	for i=#self,1,-1 do
		enemy_grid:insert(self[i])
	end

	for i=#self,1,-1 do
		local e = self[i]
		e:update(plr)
		if e.dead then
			deli(self, i)
		end
	end
end

function enemies_draw(self)
	for e in all(self) do
		if cam:in_frame(e.area) then
			e:draw()
			if e.pos.x < 128 then
				e.pos.x+=width
				e:draw()
				e.pos.x-=width
			elseif width - e.pos.x < 128 then
				e.pos.x-=width
				e:draw()
				e.pos.x+=width
			end
		end
	end
end
