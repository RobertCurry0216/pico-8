director = class:extend()

enemy_spawners = {
  bomber_group_small={
    difficulty=2,
    spawn=function(store)
      local x = plr.pos.x + (sign(plr.momentum.x) * 200)
      add(store, bomber(x))
      add(store, bomber(x+10))
    end
  },
  bomber_group={
    difficulty=4,
    spawn=function(store)
      local x = plr.pos.x + (sign(plr.momentum.x) * 200)
      add(store, bomber(x))
      add(store, bomber(x+10))
      add(store, bomber(x+20))
      add(store, bomber(x+30))
    end
  },
  boat={
    difficulty=4,
    spawn=function(store)
      add(store, boat(rnd(width)))
    end
  },
  debug={
    difficulty=1000,
    spawn=function(store)
      for i=1,40 do
        add(store, bomber(rnd(width)))
      end
    end
  }
}

function director:new(store)
  self.store = store
  self.difficulty = 1
  self.current_difficulty = 0
  self.enemy_pool = {enemy_spawners.debug}
  self.handlers = {}
  self.timer = timer.new()

  --listeners
  self.listen_on_enemy_die = function(...) self:on_enemy_die(...) end
  register("enemy_die", self.listen_on_enemy_die)

  --timers
  self.timer:every(60, function() self.difficulty += 1 end)
  self.timer:every(150, function() self:spawn_wave() end)

  --enemy pool updates
  self.timer:after(160, function() self.enemy_pool = {enemy_spawners.bomber_group} end)
  self.timer:after(300, function() add(self.enemy_pool, enemy_spawners.boat) end)

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