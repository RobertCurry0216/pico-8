pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--dependencies
--[[
  math.p8
]]

camera = {
  __tostring = function(self)
    return "cam:"..tostr(self.pos)
  end
}

function camera:new(x,y,z)
  --construtor
  local c = {}
  setmetatable(c, camera)
  c.pos = vector:new(x,y,z)
  c.viewheight = 1
  c.viewwidth = 1
  c.viewdist = 1
  c.background = 0

  --methods

  --gets the vector pointing from the camera
  --to the given pixel coord
  function c:coord_to_vec(x, y)
    return vector:new(
      x * (self.viewwidth / 127),
      y * (self.viewheight / 127),
      self.viewdist
    )
  end

  function c:trace_ray(x, y, scene)
    local closest_t, closest_actor, t_min, t_max, dir, ts
    closest_t = inf
    t_min = self.viewdist
    t_max = inf
    dir = self:coord_to_vec(x,y)

    for i,actor in pairs(scene) do
      ts = actor:intersects(self.pos, dir)
      if ts[1] < closest_t and t_min < ts[1] and ts[1] < t_max then
        closest_t = ts[1]
        closest_actor = i
      end
      if ts[2] < closest_t and t_min < ts[2] and ts[2] < t_max then
        closest_t = ts[2]
        closest_actor = i
      end
    end

    if closest_actor == nil then
      return 6
    end
    return scene[closest_actor].color
  end

  function c:render(scene)
    local c
    for y=-64,64 do
      for x=-64,64 do
        c = self:trace_ray(x,y,scene)
        pset(64+x,64+y,c)
      end
    end
  end

  --return
  return c
end