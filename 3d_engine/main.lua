pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-------------------------------
--main game functions
-------------------------------
function _init()
  fuck = 0.001
end

function _update60()
  -- if (btn(2)) fuck += 0.01
  -- if (btn(3)) fuck -= 0.01

  -- if (btn(1)) fuck += 1
  -- if (btn(0)) fuck -= 1

  -- debug.z = fuck


  f_near = 0.1
  f_far = 1000
  f_fov = 45
  f_aspect = 1
  f_fov_rad = 1 / tan(f_fov / 360)
  

  a = f_aspect * f_fov_rad
  b = f_fov_rad
  c = f_far / (f_far - f_near)
  d = (-f_far * f_near) / (f_far - f_near)

  -- debug.acc = 100

  mat_proj = {
    {a,0,0,0},
    {0,b,0,0},
    {0,0,c,1},
    {0,0,d,0}
  }

end

function _draw()
  cls()
  cube:draw()
  draw_debug()
end


-------------------------------
--geom constructors
-------------------------------
function vec(x, y, z)
  return {
    x=x, 
    y=y, 
    z=z,
    by_matrix = function(self, m)
      y = self.x * m[1][2] + self.y * m[2][2] + self.z * m[3][2] + m[4][2]
      x = self.x * m[1][1] + self.y * m[2][1] + self.z * m[3][1] + m[4][1]
      z = self.x * m[1][3] + self.y * m[2][3] + self.z * m[3][3] + m[4][3]
      w = self.x * m[1][4] + self.y * m[2][4] + self.z * m[3][4] + m[4][4]
      if w != 0 then
        return vec(x/w, y/w, z/w)
      end
      return vec(x, y, z)
    end,
    translate=function(self, vector)
      return vec(
        self.x + vector.x,
        self.y + vector.y,
        self.z + vector.z
      )
    end,
    scale=function(self, value)
      return vec(
        self.x * value,
        self.y * value,
        self.z * value
      )
    end
  }
end

function polyface(v1, v2, v3)
  return {
    p1=v1,
    p2=v2,
    p3=v3,
    draw=function(self)
      line(self.p1.x, self.p1.y, self.p2.x, self.p2.y, 6)
      line(self.p2.x, self.p2.y, self.p3.x, self.p3.y, 6)
      line(self.p3.x, self.p3.y, self.p1.x, self.p1.y, 6)
    end,
    by_matrix=function(self, matrix)
      return polyface(
        self.p1:by_matrix(matrix),
        self.p2:by_matrix(matrix),
        self.p3:by_matrix(matrix)
      )
    end,
    translate=function(self, vector)
      return polyface(
        self.p1:translate(vector),
        self.p2:translate(vector),
        self.p3:translate(vector)
      )
    end,
    scale=function(self, value)
      return polyface(
        self.p1:scale(value),
        self.p2:scale(value),
        self.p3:scale(value)
      )
    end
  }
end

function polygon(faces)
  return {
    faces=faces,
    scale=100,
    rotation=0,
    position=vec(20,20,3),
    draw=function(self)
      for _face in all(self.faces) do
        _face = _face:translate(self.position)
        _face = _face:by_matrix(mat_proj)
        _face = _face:scale(self.scale)
        _face:draw()
      end
    end
  }
end

-------------------------------
--math functions
-------------------------------
function tan(theta)
  return sin(-theta) / cos(theta)
end

-------------------------------
--matricies
-------------------------------


-------------------------------
--test cube
-------------------------------
cube = polygon({
  -- south face
  polyface(vec(0,0,0),vec(0,1,0),vec(1,1,0)),
  polyface(vec(0,0,0),vec(1,1,0),vec(1,0,0)),

  -- east face
  polyface(vec(1,0,0),vec(1,1,0),vec(1,1,1)),
  polyface(vec(1,0,0),vec(1,1,1),vec(1,0,1)),

  -- north face
  polyface(vec(1,0,1),vec(1,1,1),vec(0,1,1)),
  polyface(vec(1,0,1),vec(0,1,1),vec(0,0,1)),

  -- west face
  polyface(vec(0,0,1),vec(0,1,1),vec(0,1,0)),
  polyface(vec(0,0,1),vec(0,1,0),vec(0,0,0)),

  -- top face
  polyface(vec(0,1,0),vec(0,1,1),vec(1,1,1)),
  polyface(vec(0,1,0),vec(1,1,1),vec(1,1,0)),

  -- bottom face
  polyface(vec(1,0,1),vec(0,0,1),vec(0,0,0)),
  polyface(vec(1,0,1),vec(0,0,0),vec(1,0,0))
})