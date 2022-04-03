follow_cam = class:extend()

function follow_cam:new(follow)
  self.follow = follow
  self.pos = follow and follow.pos - vector(64,64) or vector(64,64)
  self.max_offset = 32
  self.offset = vector()
  self.i_points = {}
  self.shake_time = 0
  self.shake_value = 0
end

function follow_cam:update()
  --add interest
  local i_point = vector()
  if #self.i_points > 0 then
    for p in all(self.i_points) do
      i_point += self.follow.pos:to(p)
    end
    i_point /= #self.i_points

    self.i_points = {}
  end

  --set pos
  self.offset += (i_point - self.offset) * 0.01
  self.offset:limit(self.max_offset)
  self.pos = self.offset + self.follow.pos - vector(64,64)

  --shake
  if self.shake_time > 0 then
    self.shake_time -= 1
    self.pos += vector.from_polar(rnd(1), self.shake_value)
  else
    self.shake_value = 0
  end

  --apply limit
  if self.bounds then
    local x1,y1,x2,y2 = unpack(self.bounds)
    local w = x2 - x1
    if self.pos.x < x1 then
      self.pos.x += w
    elseif self.pos.x > x2 then
      self.pos.x -= w
    end
    self.pos.y = mid(self.pos.y, y1, y2)
  end

  --set camera
  camera(self.pos.x, self.pos.y)
end


function follow_cam:add_interest(p)
  add(self.i_points, p)
end

function follow_cam:shake(t, v)
  self.shake_time = max(self.shake_time, t or 10)
  self.shake_value = max(self.shake_value, v or 5)
end