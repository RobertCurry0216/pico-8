function seek(vechicle, target)
  local desired = target.pos - vechicle.pos
  desired:limit(vechicle.max_speed)
  local steering = desired - vechicle.vel
  return steering
end