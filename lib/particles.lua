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
    if p.x < 128 then
      p.x+=width
      self[p.name].draw(p)
      p.x-=width
    elseif width - p.x < 128 then
      p.x-=width
      self[p.name].draw(p)
      p.x+=width
    end
	end
end