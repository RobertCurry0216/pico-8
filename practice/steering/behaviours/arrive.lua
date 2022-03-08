function arrive(vechicle, target)
  local desired = target - vechicle.pos
  desired:limit(vechicle.max_speed)
  local steering = desired - vechicle.vel
  return steering
end