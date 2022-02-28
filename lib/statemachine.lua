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
state = class:extend()
state.name = "state"

function state:on_enter() end
function state:on_exit() end

function state:__tostring() 
	return "<state: "..self.name..">"
end
