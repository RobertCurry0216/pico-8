sp_grid = class:extend()

function sp_grid:new(width, height, size)
  self.rows = ceil(height / size)
  self.cols = ceil(width / size)
  self.row_height = height / self.rows
  self.col_width = width / self.cols

  self:clear()
end

function sp_grid:clear()
  self.areas = {}
  for y=0,self.rows do
    self.areas[y] = {}
    for x=0,self.cols do
      self.areas[y][x] = {}
    end
  end
end

function sp_grid:insert(area)
  local x = max(0, flr(area.pos.x / self.col_width))
  local y = max(0, flr(area.pos.y / self.row_height))

  add(self.areas[y][x], area)
end

function sp_grid:get(area)
  local values = {}
  local x0 = max(0, flr(area.pos.x / self.col_width))
  local x1 = min(self.cols, ceil((area.pos.x + area.size.x) / self.col_width))
  local y0 = max(0, flr(area.pos.y / self.row_height))
  local y1 = min(self.rows, ceil((area.pos.y + area.size.y) / self.row_height))

  for y=y0,y1 do
    for x=x0,x1 do
      for v in all(self.areas[y][x]) do
        if area:overlaps(v) then
          add(values, v)
        end
      end
    end
  end

  return values
end