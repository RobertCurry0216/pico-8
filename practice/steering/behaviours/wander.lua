function wander()
  local theta = 0

  return function(vechicle)
    local c = vechicle.vel:copy()
    c:set_mag(10)
    theta += rnd(0.3) - 0.15
    local desired = c + vector.from_polar(theta + vechicle.vel:angle(), 1)
    desired:limit(vechicle.max_speed)
    return desired - vechicle.vel
  end
end