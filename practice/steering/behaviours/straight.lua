function straight()
  local straight_direction = vector(rnd(10)-5, rnd(10)-5)
  return function(vechicle, target)
    return straight_direction
  end
end