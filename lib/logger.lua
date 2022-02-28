-->8
-- debugging helpers
--  by pancelor

-- your swiss army knife
--  for debugging is this
--  one function right here:
-- use it to check what your
--  computer is actually doing!
-- usage:
--  pq(x,y)
--  (this mimics printh(x..y))
function log(...)
  printh(q(...))
end
 
 -- quotes a single argument
 -- like tostr, but can also
 --  print tables
function q1(x)
  return type(x)=="table"
   and qt(x)
   or tostr(x)
end
 
 -- quotes and returns its
 --  arguments
 -- usage:
 --  ?q("p.x=",x,"p.y=",y)
 function q(...)
  local args=pack(...)
  local s=""
  for i=1,args.n do
   s..=q1(args[i]).." "
  end
  return s
 end
 
 -- quotes a table
 function qt(t,sep)
  local s="{"
  for k,v in pairs(t) do
   s..=q1(k)
   s..="="..q1(v)..(sep or ",")
  end
  return s.."}"
 end
 
 -- quotes an array
 function qa(t)
  local s="{"
  for v in all(t) do
   s..=q1(v)..","
  end
  return s.."}"
 end
 
 -- sorta like sprintf (from c)
 -- usage:
 --  ?qf("p={x=%,y=%}",p.x,p.y)
 function qf(...)
  local args=pack(...)
  local fstr=args[1]
  local argi=2
  local s=""
  for i=1,#fstr do
   local c=sub(fstr,i,i)
   if c=="%" then
    s..=q1(args[argi])
    argi+=1
   else
    s..=c
   end
  end
  return s
 end