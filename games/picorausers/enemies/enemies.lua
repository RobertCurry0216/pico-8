enemies = {}

function enemies:update(plr)
	for i=#self,1,-1 do
		local e = self[i]
		e:update(plr)

		if e.dead then
			deli(self, i)
		end
	end
end

function enemies:draw()
	for e in all(self) do
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
