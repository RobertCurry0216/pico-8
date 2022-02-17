pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
---------------------------------------
--state machine
---------------------------------------
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

-->8
--example
state_a = state:new "a"

function state_a:draw()
	print("a")
end

state_b = state:new "b"

function state_b:draw()
	print("b")
end

function _init()
	sm = statemachine:new(state_a, state_b)
end

function _draw()
	if btnp(❎) then
		sm:goto_state "b"
	end
	if btnp(🅾️) then
		sm:goto_state "a"
	end

	cls()
	sm:draw()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
