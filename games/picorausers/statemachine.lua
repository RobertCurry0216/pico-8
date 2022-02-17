statemachine = {
	__index=function(self, key)
		return self.state[key]
	end
}

function statemachine:new(...)
	local states = {...}
	local sm = setmetatable({
		-- properties
		states = {},

		-- methods
		goto_state = function(self, name, ...)
			self.state:on_exit(...)
			self.state = self.states[name]
			self.state:on_enter(...)
		end,
	}, statemachine)

  for s in all(states) do
    sm.states[s.name] = s
  end

  sm.state = states[1]
	return sm
end

--states
state = {
	__tostring=function(self)
		return "<state: "..self.name..">"
	end,
  --[[provides an empty function for
      any callback not overridden]]
  __index=function() return function() end end
}
function state:new(name)
	return setmetatable({name = name}, state)
end