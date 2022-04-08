function vline(p1, p2, ...)
  line(p1.x, p1.y, p2.x, p2.y, ...)
end

function cprint(str, x, y, ...)
  print(str, x-#str*2, y-3, ...)
end