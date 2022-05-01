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
  spawn=function(store,x,y,delay)
    delay = delay or rnd(4)
    add(store, {name="smoke_puff", x=x, y=y, life=6, col=2, r=2+rnd(4), delay=delay})
  end,
  update=function(p)
    if p.delay > 0 then
      p.delay -= 1
    else
      p.life -= 1
    end
    if p.life <= 4 then
      p.col = 7
    end
  end,
  draw=function(p)
    if p.delay > 0 then return end
    circfill(p.x, p.y, p.r, p.col)
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

particles:add_type({
  name="boat_hull",
  spawn=function(store,x,y)
    add(store, {
      name="boat_hull",
      x=x, y=y,
      life=64
    })
  end,
  update=function(p)
    p.life-=1
    p.y+=0.25
  end,
  draw=function(p)
    spr(96, p.x, p.y, 4, 2)
  end
})

particles:add_type({
  name="boat_sink",
  spawn=function(store,x,y)
    for i=1,rnd(10)+10 do
      particles:spawn("smoke_puff", x+rnd(32), y+rnd(8)+4, rnd(16))
    end
    particles:spawn("boat_hull", x, y)
  end
})

particles:add_type({
  name="submarine_hull",
  spawn=function(store,x,y)
    add(store, {
      name="submarine_hull",
      x=x, y=y,
      life=64
    })
  end,
  update=function(p)
    p.life-=1
    p.y+=0.25
  end,
  draw=function(p)
    spr(100, p.x, p.y, 6, 2)
  end
})

particles:add_type({
  name="submarine_sink",
  spawn=function(store,x,y)
    for i=1,rnd(20)+10 do
      particles:spawn("smoke_puff", x+rnd(42), y+rnd(8)+4, rnd(16))
    end
    particles:spawn("submarine_hull", x, y)
  end
})

particles:add_type({
  name="blimp_die",
  spawn=function(store,x,y)
    for i=1,rnd(30)+10 do
      particles:spawn("smoke_puff", x+rnd(32), y+rnd(16), rnd(16))
    end
  end
})