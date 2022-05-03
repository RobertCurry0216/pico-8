function sign(v)
  return v < 0 and -1 or 1
end

function map_to(value, start1, stop1, start2, stop2)
  return start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1))
end