function join(a,b)
  local t = {}
  for v in all(a) do
    add(t,v)
  end
  for v in all(b) do
    add(t,v)
  end
  return t
end

function round(v)
  return flr(v+0.5)
end

function interpol(i1,d1,i2,d2)
  i1,i2 = round(i1), round(i2)
  if i1 == i2 then
    return {d1}
  end
  local values = {}
  local a = (d2-d1)/(i2-i1)
  local d = d1
  for i=i1,i2 do
    add(values, d)
    d+=a
  end
  return values
end

function trifill(x1,y1,x2,y2,x3,y3,c)
  if y2 < y1 then x1,y1, x2,y2 = x2,y2, x1,y1 end
  if y3 < y1 then x1,y1, x3,y3 = x3,y3, x1,y1 end
  if y3 < y2 then x3,y3, x2,y2 = x2,y2, x3,y3 end
  local ymax = ceil(y3-y1)
  color(c)

  -- find x values
  local x12 = interpol(y1,x1,y2,x2)
  local x23 = interpol(y2,x2,y3,x3)
  local x13 = interpol(y1,x1,y3,x3)
  deli(x12)
  local x123 = join(x12,x23)

  --draw lines
  for y=1,ymax do
    line(x13[y],y+y1,x123[y],y+y1,c)
  end

  color()
end

function vtrifill(p1, p2, p3, c)
  trifill(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, c)
end