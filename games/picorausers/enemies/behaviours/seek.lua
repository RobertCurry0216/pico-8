function seek(target)
  return function(vechicle)
    local desired = target.pos - vechicle.pos
    desired:limit(vechicle.max_speed)
    return desired - vechicle.vel
  end
end