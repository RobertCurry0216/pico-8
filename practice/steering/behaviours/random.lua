function random()
  local s = straight()

  timer:every(30, function() s = straight() end, 999999)

  return function(vechicle, target)
    return s(vechicle, target)
  end

end