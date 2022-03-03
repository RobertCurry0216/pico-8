quadtree = class:extend()

--[[
  items inserted into quadtree must have an area of type 'rect_area'
]]

function quadtree:new(area, depth)
  self.depth = depth or 0
  self:resize(area)
end

function quadtree:resize(area)
  self:clear()
  self.area = area

  local child_size = area.size / 2
  self.child_areas = {
    rect_area(area.pos, child_size),
    rect_area(vector(area.pos.x+child_size.x, area.pos.y), child_size),
    rect_area(vector(area.pos.x, area.pos.y+child_size.y), child_size),
    rect_area(area.pos+child_size, child_size),
  }
end

function quadtree:clear()
  self._items = {}
  self.children = {}
end

function quadtree:size()
  local count = #self.items
  for i=1,4 do
    local c = self.children[i]
    count += c and c:size() or 0
  end
  return size
end

function quadtree:insert(item)
  for i=1,4 do
    local ca = self.child_areas[i]
    if ca:contains(item) and self.depth < 8 then
      local child = self.children[i]
      if not child then
        self.children[i] = quadtree(self.child_areas[i], self.depth + 1)
      end
      self.children[i]:insert(item)
      return
    end
  end
  add(self._items, item)
end

function quadtree:search(area, items)
  local items = items or {}
  for item in all(self._items) do
    if area:overlaps(item) then --TODO make area a prop
      add(items, item)
    end
  end

  --children
  for i=1,4 do
    local c = self.children[i]
    if c and self.child_areas[i]:overlaps(area) then
      if area:contains(self.child_areas[i]) then
        c:items(items)
      else
        c:search(area, items)
      end
    end
  end
  return items
end

function quadtree:items(items)
  local items = items or {}

  for item in all(self._items) do
    add(items, item)
  end

  for i=1,4 do
    if self.children[i] then
      self.children[i]:items(items)
    end
  end
  return items
end