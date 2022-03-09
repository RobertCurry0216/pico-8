function seek(target)
  return function(vechicle)
    --seperate
    local v_sep = vector()
    for e in all(enemies) do
      if e != vechicle then
        v_sep -= (e.pos - vechicle.pos):norm()
      end
    end
    v_sep:limit(1)

    --seek
    local desired = target.pos - vechicle.pos
    desired:limit(vechicle.max_speed)
    local v_seek = desired - vechicle.vel
    local s = v_seek + v_sep

    return s
  end
end
