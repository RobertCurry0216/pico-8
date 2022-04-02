director = class:extend()

function director:new(store)
  self.store = store
  self.difficulty = 4
  self.current_difficulty = 0
  self.enemy_pool = {bomber, bomber}
  self.handlers = {}

  --listeners
  self.listen_on_enemy_die = function(...) self:on_enemy_die(...) end
  register("enemy_die", self.listen_on_enemy_die)

  --timers
  add(self.handlers, timer:every(45, function() self.difficulty += 1 end))
  add(self.handlers, timer:every(150, function() self:spawn_wave() end))

  --enemy pool updates

  --initial wave
  self:spawn_wave()
end

function director:destroy()
  for h in all(self.handlers) do
    timer:cancel(h)
  end

  unregister("enemy_die", self.listen_on_enemy_die)
end


function director:spawn_wave()
  local count = 0
  while self.current_difficulty < self.difficulty and count < 6 do
    count += 1
    local e = choose(self.enemy_pool)()
    self.current_difficulty += e.difficulty
    add(self.store, e)
  end
end

function director:on_enemy_die(e)
  self.current_difficulty -= e.difficulty
end