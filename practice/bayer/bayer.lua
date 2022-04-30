DITHER_MAP = {[0]=1,9,3,11,13,5,15,7,4,12,2,10,16,8,14,6}

function dither(x, y, l)
  x, y = x%4, y%4
  return DITHER_MAP[x+y*4] > l * 17
end