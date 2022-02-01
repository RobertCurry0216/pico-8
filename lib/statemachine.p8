pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
--state machine
statemachine = {}

function statemachine:new()
	return setmetatable({
		-- properties
		states = {},

		-- methods
		update = function(self, ...)
			self.state:update(...)
		end,

		draw = function(self, ...)
			self.state:draw(...)
		end,

		goto_state = function(self, name, ...)
			self.state:on_exit(...)
			self.state = self.states[name]
			self.state:on_enter(...)
		end,

		add_state = function(self, state)
			self.states[state.name] = state
		end,
	}, statemachine)
end

-- states
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

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
