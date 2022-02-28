function persue(vechicle, target)
  local future_pos = target.pos + target.vel * 3
  local desired = future_pos - vechicle.pos
  desired:limit(vechicle.max_speed)
  local steering = desired - vechicle.vel
  return steering
end