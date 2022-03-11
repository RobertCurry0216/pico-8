particles:add_type({
	name="dot",
	spawn=function(store, x,y)
		add(store, {name="dot", x=x, y=y, life=20})
	end,

	update=function(p)
		p.life -= 1
	end,

	draw=function(p)
		pset(p.x, p.y, 7)
	end
})

particles:add_type({
  name="circle",
  spawn=function(store,x,y)
    add(store, {name="circle", x=x, y=y, r=4, life=12})
  end,
  update=function(p)
    p.life -= 1
    p.r *= 0.9
  end,
  draw=function(p)
    circfill(p.x, p.y, p.r, 7)
  end
})

particles:add_type({
  name="smoke_puff",
  spawn=function(store,x,y)
    add(store, {name="smoke_puff", x=x, y=y, life=6+rnd(4), col=2, r=2+rnd(4)})
  end,
  update=function(p)
    p.life -= 1
    if p.life <= 4 then
      p.col = 7
    end
  end,
  draw=function(p)
    if p.life <= 6 then
      circfill(p.x, p.y, p.r, p.col)
    end
  end
})

particles:add_type({
  name="smoke_cloud",
  spawn=function(store,x,y)
    for i=1,rnd(10) do
      particles:spawn("smoke_puff", x-3+rnd(6), y-3+rnd(6))
    end
  end
})