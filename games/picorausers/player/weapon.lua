weapon = class:extend()

function weapon:new(weapon_type)
  self.weapon_type = weapon_type
  self.can_shoot = true
end

function weapon:shoot(pos, heading, momentum)
  if self.can_shoot then
    self.can_shoot = false
    timer:after(5, function() self.can_shoot = true end)
    add(bullets, self.weapon_type(pos + heading*5, heading*4 + momentum, 60))
  end
end