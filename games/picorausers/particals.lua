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

particles:add_type({
  name="debris",
  spawn=function(store,x,y,d)
    add(store,{
      name="debris",
      x=x, y=y,
      life=10,
      col=2,
      dir=d or vector.from_polar(rnd(0.5)+0.5, rnd(2))
    })
  end,
  update=function(p)
    p.life -= 1
    p.x += p.dir.x
    p.y += p.dir.y
    p.dir.x *= 0.95
    p.dir.y += 0.2
  end,
  draw=function(p)
    pset(p.x, p.y, p.col)
  end
})

particles:add_type({
  name="text",
  spawn=function(store,x,y,str)
    add(store,{
      name="text",
      str=tostr(str),
      x=x, y=y,
      life=20
    })
  end,
  update=function(p)
    p.y -= cos(p.life / 40) * -1
    p.life -= 1
  end,
  draw=function(p)
    print(p.str, p.x, p.y, 2)
  end
})