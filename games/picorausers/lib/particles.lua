particles = {}

function particles:add_type(handler)
	self[handler.name] = handler
	self.store = {}
end

function particles:spawn(name, ...)
	self[name].spawn(self.store, ...)
end

function particles:update()
	for i=#self.store,1,-1 do
		local p = self.store[i]
		self[p.name].update(p)

		if p.life <= 0 then
			deli(self.store, i)
		end
	end
end

function particles:draw()
	for p in all(self.store) do
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