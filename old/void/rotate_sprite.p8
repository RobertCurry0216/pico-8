pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

sprites = {}

-- scaling pico sprites
-- by @mykie on twitter
function init_sprite(num, name)
  -- this indexes a single sprite which
  --  is a 2d array of color ids
  cls()
  spr(num,0,0)
  local sprite={}
  for x=1,8 do
   sprite[x]={}
   for y=1,8 do
    sprite[x][y]=pget(x-1,y-1)
   end
  end
  sprites[name] = sprite
  cls()
end
 
 -- draws a sprite at posx,posy with
 --  the origin in the center
 --  s is the scale, a is angle
function scalespr(name,posx,posy,s,a,tc)
  local sprite = sprites[name]

  -- these nine lines set origin
  local ox=posx
  local oy=posy
  local xdist=abs((posx+s/2)-posx)*8
  local ydist=abs((posy+s/2)-posy)*8
  local xsq=xdist*xdist
  local ysq=ydist*ydist
  local rad=sqrt(xsq+ysq)
  local x0=angle(ox,oy,rad,a+225).x
  local y0=angle(ox,oy,rad,a+225).y
  -- set x1 to posx and y1 to posy to
  --  move the origin to the top left
  local x1=x0
  local y1=y0
  for y=1,8 do
   for x=1,8 do
    if (sprite[x][y] ~= tc) then
      drawpixel(x1,y1,s,ang,sprite[x][y])
    end
    local angles=angle(x1,y1,s,a)
    y1=angle(x1,y1,s,a).y
    x1=angle(x1,y1,s,a).x
   end
   y1=angle(x0,y0,y*s,a+90).y
   x1=angle(x0,y0,y*s,a+90).x
  end
end
 
 -- draws a single pixel at pos x,y
 --  with the origin at the top left
 --  w is the width/height of pixel
 --  a is the angle
 --  c is the color
function drawpixel(x,y,w,a,c)
  local x1=x
  local y1=y
  if (a == nil) a = 0
  local x2=angle(x1,y1,w,a).x
  local y2=angle(x1,y1,w,a).y
  local x3=angle(x2,y2,w,a+90).x
  local y3=angle(x2,y2,w,a+90).y
  local x4=angle(x1,y1,w,a+90).x
  local y4=angle(x1,y1,w,a+90).y
  local v={x1,y1,x2,y2,x3,y3,x4,y4}
  render_poly(v,c)
end
 
 --returns an x and y position based
 -- on a vector, r=radius, 
 -- a=angle in degrees
function angle(x,y,r,a)
  local x2=x+r*cos(a/360)
  local y2=y+r*sin(a/360)*-1
  return {x=x2,y=y2}
end

 
 -- polyfill from user scgrn on 
 --  lexaloffle forums
 --  https://www.lexaloffle.com/bbs/?tid=28312
 -- draws a filled convex polygon
 -- v is an array of vertices
 -- {x1, y1, x2, y2} etc
function render_poly(v,col)
  col=col or 5
 
  -- initialize scan extents
  -- with ludicrous values
  local x1,x2={},{}
  for y=0,127 do
   x1[y],x2[y]=128,-1
  end
  local y1,y2=128,-1
 
  -- scan convert each pair
  -- of vertices
  for i=1, #v/2 do
   local next=i+1
   if (next>#v/2) next=1
 
   -- alias verts from array
   local vx1=flr(v[i*2-1])
   local vy1=flr(v[i*2])
   local vx2=flr(v[next*2-1])
   local vy2=flr(v[next*2])
 
   if vy1>vy2 then
    -- swap verts
    local tempx,tempy=vx1,vy1
    vx1,vy1=vx2,vy2
    vx2,vy2=tempx,tempy
   end 
 
   -- skip horizontal edges and
   -- offscreen polys
   if vy1~=vy2 and vy1<128 and
    vy2>=0 then
 
    -- clip edge to screen bounds
    if vy1<0 then
     vx1=(0-vy1)*(vx2-vx1)/(vy2-vy1)+vx1
     vy1=0
    end
    if vy2>127 then
     vx2=(127-vy1)*(vx2-vx1)/(vy2-vy1)+vx1
     vy2=127
    end
 
    -- iterate horizontal scans
    for y=vy1,vy2 do
     if (y<y1) y1=y
     if (y>y2) y2=y
 
     -- calculate the x coord for
     -- this y coord using math!
     x=(y-vy1)*(vx2-vx1)/(vy2-vy1)+vx1
 
     if (x<x1[y]) x1[y]=x
     if (x>x2[y]) x2[y]=x
    end 
   end
  end
 
  -- render scans
  for y=y1,y2 do
   local sx1=flr(max(0,x1[y]))
   local sx2=flr(min(127,x2[y]))
 
   local c=col*16+col
   local ofs1=flr((sx1+1)/2)
   local ofs2=flr((sx2+1)/2)
   memset(0x6000+(y*64)+ofs1,c,ofs2-ofs1)
   
    pset(sx1,y,c)
    pset(sx2,y,c)
  end 
end
 