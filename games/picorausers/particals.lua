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