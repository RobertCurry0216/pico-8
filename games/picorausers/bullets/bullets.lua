bullets = {}

function bullets_update(self)
	for i=#self,1,-1 do
		local b = self[i]
		b:update()

		if b.dead then
			deli(self, i)
		end
	end
end

function bullets_draw(self)
	for b in all(self) do
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
