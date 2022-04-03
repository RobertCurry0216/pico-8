director = class:extend()

enemy_spawners = {
  bomber_group={
    difficulty=5,
    spawn=function(store)
      local x = plr.pos.x + (sign(plr.momentum.x) * 200) - 20
      add(store, bomber(x)) x+= 10
      add(store, bomber(x)) x+= 10
      add(store, bomber(x)) x+= 10
      add(store, bomber(x)) x+= 10
      add(store, bomber(x))
    end
  },
  boat={
    difficulty=3,
    spawn=function(store)
      add(store, boat(plr.pos.x-64 + rnd(128)))
    end
  }
}

function director:new(store)
  self.store = store
  self.difficulty = 1
  self.current_difficulty = 0
  self.enemy_pool = {enemy_spawners.boat, enemy_spawners.bomber_group}
  self.handlers = {}
  self.timer = timer.new()

  --listeners
  self.listen_on_enemy_die = function(...) self:on_enemy_die(...) end
  register("enemy_die", self.listen_on_enemy_die)

  --timers
  self.timer:every(90, function() self.difficulty += 1 end)
  self.timer:every(150, function() self:spawn_wave() end)

  --enemy pool updates

  --initial wave
  self:spawn_wave()
end

function director:update()
  self.timer:update()
end

function director:destroy()
  self.timer:clear()
  unregister("enemy_die", self.listen_on_enemy_die)
end


function director:spawn_wave()
  local count = 0
  while self.current_difficulty < self.difficulty and count < 2 do
    count += 1
    local spawner = choose(self.enemy_pool)
    self.current_difficulty += spawner.difficulty
    spawner.spawn(self.store)
  end
end

function director:on_enemy_die(e)
  self.current_difficulty -= e.difficulty
end