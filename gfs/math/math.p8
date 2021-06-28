pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--constants
inf =  32767

darkenshademap = {
		"0,0,0,0,0,0",
		"1,1,1,0,0,0",
		"2,2,1,1,0,0",
		"3,3,3,1,1,0",
		"4,2,2,1,1,0",
		"5,5,1,1,1,0",
		"6,6,13,5,1,0",
		"7,7,6,13,1,0",
		"8,8,2,2,1,0",
		"9,4,2,2,1,0",
		"10,9,4,2,1,0",
		"11,11,3,3,1,0",
		"12,12,13,5,1,0",
		"13,13,5,1,1,0",
		"14,14,4,2,1,0",
		"15,9,4,2,1,0",
	}

--utils
function round(v)
  return flr(v+0.5)
end

function darken(c,v)
	return tonum(split(darkenshademap[c+1])[v])
end

function join(a,b)
  local t = {}
  for v in all(a) do
    add(t,v)
  end
  for v in all(b) do
    add(t,v)
  end
  return t
end

-->8
--vectors
vector = {
  __tostring = function(self)
		return "<"..self.x..":"..self.y..":"..self.z..">"
  end,
  __add = function(self, other)
    local v = vector:new()
    v.x = self.x + other.x
    v.y = self.y + other.y
    v.z = self.z + other.z
    return v
  end,
  __sub = function(self, other)
    local v = vector:new()
    v.x = self.x - other.x
    v.y = self.y - other.y
    v.z = self.z - other.z
    return v
  end,
  __mul = function(self, other)
    local v = vector:new()
    v.x = self.x * other
    v.y = self.y * other
    v.z = self.z * other
    return v
  end,
  __div = function(self, other)
    local v = vector:new()
    v.x = self.x / other
    v.y = self.y / other
    v.z = self.z / other
    return v
  end,
  __len = function(self)
    return sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
  end
}

function vector:new(x, y, z)
  --constructor
  local v = {}
  setmetatable(v, vector)
  v.x = x or 0
  v.y = y or 0
  v.z = z or 0

  --methods
  function v:copy()
    return vector:new(self.x, self.y, self.z)
  end

  function v:dot(other)
	  return (self.x * other.x) + (self.y * other.y) + (self.z * other.z)
  end

  function v:cross(other)
    local v = vector:new()
    v.x = (self.y * other.z) - (self.z * other.y)
    v.y = (self.z * other.x) - (self.x * other.z)
    v.z = (self.x * other.y) - (self.y * other.x)
    return v
  end

  function v:norm()
    local v = self:copy()
    return v/#self
  end

  return v
end

transform = {
  __tostring = function(self)
    return "<".."transform:"..self.scale..":"..tostr(self.translation)..":"..tostr(self.rotation)..">"
  end
}

function transform:new(scale, rotation, translation)
  --constructor
  local t = {}
  t.scale = scale or 1
  t.rotation = rotation or vector:new()
  t.translation = translation or vector:new()
  --methods

  --end class
  return t
end

--vector helpers
function v_update(self,other)
  self.x += other.x
  self.y += other.y
  self.z += other.z
end

function v_applytransform(v, transform)
  local scaled = v_applyscale(v, transform.scale)
  local rotated = v_applyrotation(scaled, transform.rotation)
  local translated = v_applytranslation(rotated, transform.translation)
  return translated
end

function v_applyscale(v, scale)
  return v * scale
end

function v_applyrotation(v, rotation)
  return v
end

function v_applytranslation(v, translation)
  return v + translation
end

-->8
--matrix

function make_yrotmatrix(theta)
  local _cos = cos(theta)
  local _sin = sin(theta)
  return {
    {_cos, 0,-_sin, 0},
    {   0, 1,    0, 0},
    {_sin, 0, _cos, 0},
    {   0, 0,    0, 1}
  }
end

function make_transmatrix(trans)
  return {
    {1,0,0,trans.x},
    {0,1,0,trans.y},
    {0,0,1,trans.z},
    {0,0,0,      1}
  }
end

function make_scalematrix(s)
  return {
    {s,0,0,0},
    {0,s,0,0},
    {0,0,s,0},
    {0,0,0,1},
  }
end

function mul_matv(mat, v)
  local result = {0,0,0,0}
  local vec = {v.x,v.y,v.z,v.w}
  for i=1,4 do
    for j=1,4 do
      result[i] += mat[i][j]*vec[j]
    end
  end
  return result
end

function mul_matmm4(m1,m2)
  local result = {
    {0,0,0,0},
    {0,0,0,0},
    {0,0,0,0},
    {0,0,0,0}
  }
  for i=1,4 do
    for j=1,4 do
      for k=1,4 do
        result[i][j] += m1[i][k]*m2[k][j]
      end
    end
  end
  return result
end

function transpose_mat(m)
  local result = {
    {0,0,0,0},
    {0,0,0,0},
    {0,0,0,0},
    {0,0,0,0}
  }
  for i=1,4 do
    for j=1,4 do
      result[i][j] = m1[j][i]
    end
  end
  return result
end