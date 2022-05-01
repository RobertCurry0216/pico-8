function follow(target, vechicle)
  local target_point = target.pos:to(vechicle.pos)
  target_point:set_mag(100)
  target_point += target.pos
  return seek({pos=target_point}, vechicle)
end
