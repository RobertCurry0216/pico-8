class={
	extend = function (self, subtype)
	subtype = subtype or {}
  subtype.super = self
 	local meta={__index=subtype}
 	return setmetatable(subtype,{
  	__index = self,
  	__call=function(self, ...)
 		 local instance=setmetatable({},meta)
  	 return instance,instance:new(...)
   end
  })
 end,
 new = function() end,
}