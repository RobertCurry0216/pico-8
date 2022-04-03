function seek(target)
  return function(vechicle)
    --seperate
    local v_sep = vector()
    for e in all(enemies) do
      if e != vechicle and (e.pos - vechicle.pos):magsq() < 100 then
        v_sep -= (e.pos - vechicle.pos):norm()
      end
    end
    v_sep:limit(1)

    --seek
    local desired = vechicle.pos:to(target.pos)
    desired:set_mag(vechicle.max_speed)
    local v_seek = desired - vechicle.vel
    local s = v_seek + v_sep

    return s
  end
end
