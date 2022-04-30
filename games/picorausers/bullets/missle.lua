missle = base_bullet:extend()

function missle:new(...)
  self.super.new(self, ...)
  self.damage = 1
  self.trail_handler = timer:every(3, function()
    particles:spawn("dot", self.pos.x, self.pos.y)
  end)

  self.wiggle = rnd()
end

function missle:die()
  self.super.die(self)
  timer:cancel(self.trail_handler)
end

function missle:draw()
  --circfill(self.pos.x, self.pos.y, 2, 2)

  local heading = self.vel:norm()
  local tip = self.pos + heading * 3
  heading:rotate(0.25)
  heading *= 1
  vline(tip, self.pos + heading, 2)
  vline(tip, self.pos - heading, 2)
end

function missle:steering()
  self.wiggle += 0.01
  local v_wiggle = self.vel:norm() * 3
  v_wiggle:rotate(sin(self.wiggle))
  local v_seek = seek(plr, self)
  return v_seek + v_wiggle
end