function _init()
  use_quad = false

  areas = {}
  a = rect_area(vector(0,0), vector(128,128))
  quad = quadtree(a)
  for i=1,1000 do
    local r = rect_area(vector(rnd(128), rnd(128)), vector(rnd(5) + 1, rnd(5) + 1))
    r.col = flr(rnd(16))
    r.vel = vector(rnd(2)-1, rnd(2)-1) * 2
    add(areas, r)
    quad:insert(r)
  end

  vis = rect_area(vector(rnd(108), rnd(108)), vector(20,20))
  vis.vel = vector(rnd(2)-1, rnd(2)-1) * 2
end

function _update()
  if btnp(2) then
    use_quad = not use_quad
  end

  vis.pos += vis.vel
  if vis.pos.x < 0 or vis.pos.x > 108 then
    vis.vel.x *= -1
  end
  if vis.pos.y < 0 or vis.pos.y > 108 then
    vis.vel.y *= -1
  end

  -- for r in all(areas) do
  --   r.pos += r.vel
  --   if r.pos.x < 0 or r.pos.x > 128 then
  --     r.vel.x *= -1
  --   end
  --   if r.pos.y < 0 or r.pos.y > 128 then
  --     r.vel.y *= -1
  --   end
  -- end
end

function _draw()
  cls()
  local visable = {}

  if use_quad then 
    visable = quad:search(vis)
  else
    for r in all(areas) do
      if vis:overlaps(r) then
        add(visable, r)
      end
    end
  end

  for r in all(areas) do
    rectfill(
      r.pos.x,
      r.pos.y,
      r.pos.x + r.size.x,
      r.pos.y + r.size.y,
      1
    )
  end


  for r in all(visable) do
    rectfill(
      r.pos.x,
      r.pos.y,
      r.pos.x + r.size.x,
      r.pos.y + r.size.y,
      r.col
    )
  end

  rect(
    vis.pos.x,
    vis.pos.y,
    vis.pos.x + vis.size.x,
    vis.pos.y + vis.size.y,
    7
  )

  if use_quad then
    print("quad")
  else
    print("list")
  end
  print("vis: "..tostr(#visable))
end