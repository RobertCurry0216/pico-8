function seek(target, vechicle)
  local desired = vechicle.pos:to(target.pos)
  desired:set_mag(vechicle.max_speed)
  return desired - vechicle.vel
end
