pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

--make the camera.
function m_cam(target)
	return {
		tar=target,--target to follow.
		pos=target.pos:copy"",
		
		--how far from center of screen target must
		--be before camera starts following.
		--allows for movement in center without camera
		--constantly moving.
		pull_threshold=16,

		--min and max positions of camera.
		--the edges of the level.
		pos_min=m_vec(64, 64),
		pos_max=m_vec(64, 192),
		
		shake_remaining=0,
		shake_force=0,

		update=function(self)

			self.shake_remaining=max(0,self.shake_remaining-1)
			
			--follow target outside of
			local _x, _y = self.tar.pos.x, self.tar.pos.y
			--pull range.
			if self:pull_max_x""<_x then
				self.pos.x+=min(_x-self:pull_max_x"",4)
			end
			if self:pull_min_x"()">_x then
				self.pos.x+=min((_x-self:pull_min_x"()"),4)
			end
			if self:pull_max_y"()"<_y then
				self.pos.y+=min(_y-self:pull_max_y"()",4)
			end
			if self:pull_min_y"()">_y then
				self.pos.y+=min((_y-self:pull_min_y"()"),4)
			end

			--lock to edge
			if(self.pos.x<self.pos_min.x)self.pos.x=self.pos_min.x
			if(self.pos.x>self.pos_max.x)self.pos.x=self.pos_max.x
			if(self.pos.y<self.pos_min.y)self.pos.y=self.pos_min.y
			if(self.pos.y>self.pos_max.y)self.pos.y=self.pos_max.y
		end,

		cam_pos=function(self)
			--calculate camera shake.
			local shk=m_vec(0,0)
			if self.shake_remaining>0 then
				shk.x=rnd(self.shake_force)-(self.shake_force/2)
				shk.y=rnd(self.shake_force)-(self.shake_force/2)
			end
			return self.pos.x-64+shk.x,self.pos.y-64+shk.y
		end,

		pull_max_x=function(self)
			return self.pos.x+self.pull_threshold
		end,

		pull_min_x=function(self)
			return self.pos.x-self.pull_threshold
		end,

		pull_max_y=function(self)
			return self.pos.y+self.pull_threshold
		end,

		pull_min_y=function(self)
			return self.pos.y-self.pull_threshold
		end,
		
		shake=function(self,ticks,force)
			self.shake_remaining=ticks
			self.shake_force=force
		end
	}
end