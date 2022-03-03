class = {}
class.__index = class


function class:new()
end


function class:extend()
  local cls = {}
  for k, v in pairs(self) do
    if sub(k,0,2) == "__" then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end


function class:__call(...)
  local obj = setmetatable({}, self)
  obj:new(...)
  return obj
end


-- function class:implement(...)
--   for _, cls in pairs({...}) do
--     for k, v in pairs(cls) do
--       if self[k] == nil and type(v) == "function" then
--         self[k] = v
--       end
--     end
--   end
-- end


-- function class:is(T)
--   local mt = getmetatable(self)
--   while mt do
--     if mt == T then
--       return true
--     end
--     mt = getmetatable(mt)
--   end
--   return false
-- end


-- function class:__tostring()
--   return "class"
-- end

