function follow(target, vechicle, dist)
  local target_point = target.pos:to(vechicle.pos)
  target_point:set_mag(dist)
  target_point += target.pos
  return seek({pos=target_point}, vechicle)
end
