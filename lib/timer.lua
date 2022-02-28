timer = {functions = {}}
setmetatable(timer, {__index=timer})

function _nothing_() end

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