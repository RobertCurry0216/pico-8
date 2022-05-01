pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
--picorausers
--by robert curry

--libs
#include lib/math.lua
#include lib/class.lua
#include lib/table_utils.lua
#include lib/particles.lua
#include lib/signal.lua
#include lib/statemachine.lua
#include lib/timer.lua
#include lib/vector.lua
#include lib/trifill.lua
#include lib/logger.lua
#include lib/rect_area.lua
#include lib/rooms.lua
#include lib/sp_grid.lua

--globals
#include globals.lua
#include utils.lua

--classes
#include particals.lua
#include director.lua

--bullets / weapons
#include player/weapon.lua
#include bullets/bullets.lua
#include bullets/base_bullet.lua
#include bullets/enemy_bullet.lua
#include bullets/missle.lua
#include bullets/big_bullet.lua

--player
#include player/state_rotate.lua
#include player/state_flying.lua
#include player/state_water.lua
#include player/state_thrust.lua
#include player/state_fall.lua
#include player/player.lua

--enemies
#include enemies/behaviours/seek.lua
#include enemies/behaviours/seperate.lua
#include enemies/behaviours/follow.lua

#include enemies/enemies.lua
#include enemies/enemy.lua
#include enemies/bomber.lua
#include enemies/boat.lua
#include enemies/submarine.lua
#include enemies/blimp.lua
#include enemies/shooter.lua

--rooms
#include rooms/welcome.lua
#include rooms/stage.lua
#include rooms/game_over.lua

--main
#include follow_cam.lua
#include main.lua	
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777770
77777777777777777007777777777777777777777777777777777777707777777777777777777777777777777777777777777777777777777777777777777770
77777777777777777770000000077777777777777777777777077777770777777777770077777777777777777770777777777770777777777777777777777700
77777777777777777770000000007777777777777777777770077777770000777777770007770777777777770000077777777000777777777777700007777000
77777777000777777770000000000077777777777777777700077777770000777777770000000777777777770000077777700000777777777700000000000000
77777777000777777770000000000000000777777700000000007777700000777777770000000077777777700000007777000000777777777700000000000000
07777770000007777000000000000000000077777000000000000777000000077777700000000000777770000000000000000000777777777700000000000000
00777700000000000000000000000000000000000000000000000000000000007777000000000000000000000000000000000000777777777700000000000000
00000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077777777000000000000000
00000000770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007777770000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000077000000000000000000000000000000000000000000000000000000000700000000000000000770000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000007770000000000000000770000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000007770000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000002222222222222200000000000000000000000000000
00000000000000000000020000000000000000000000000000000000000000000000000000000000000222222222222002222000000000000000000000000000
00000000000000000002222000000000000000000000000000000000000000000000000000000000002222222222222220002200000000000000000000000000
00000000000222002220020202000000000000000000000022200000000000000000000000000000022222222222222222220220000000000000000000000000
00000000002222220000020022200000000000000000000022200000000000000000000000000000222222222222222222222022000000000000000000000000
00000002002222000000020002000000000000000000000022200000000000000000000000000000220222222222222222222222000000000000000000000000
00000222002222000000020022200000000000002220000022200222222000000000002200000000022022222222222222222220000000000000000000000000
00000222002222000000222022200000000000002220000022200222222000000000002200000000002200222222222222222200000000000000000000000000
22222222222222222222222222222222000022222222222222222222222222222222222222220000000222000022222222222000000000000000000000000000
22222222222222222222222222222222002222222222222222222222222222222222222222222200000002222222222222200000000000000000000000000000
02220020222200000000000000002220022222222222222222222222222222222222222222222220000000000200002000000000000000000000000000000000
02220202022222222222222222222220022220000000000000000000000000022222000000002220000000002222222200000000000000000000000000000000
00222222222222222222222222222200222222222222222222222222222222222222222222222222000000002002200200000000000000000000000000000000
00022222222222222222222222222000222222222222222222222222222222222222222222222222000000002222222200000000000000000000000000000000
00002222222222222222222222220000222222222222222222222222222222222222222222222222000000002222222200000000000000000000000000000000
00000222222222222222222222200000222222222222222222222222222222222222222222222222000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000020002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000020000000000000020002000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000
00000220002000000000222002200000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000
22002220002000022202222202220000000000000000222000000002200000000020000000000000000000000000000000000000000000000000000000000000
22222220002200022022222022222000002200000000222200000022200000020022000000022200000000000000000000000000000000000000000000000000
02220020022200002000000000002000022200000000222200022222220000222022200000222220000000000000000000000000000000000000000000000000
02220202022220002222202202222020022220000000000000000000000000022022000000002220000000000000000000000000000000000000000000000000
00222222222222022222022220222200222220200220222200222222220002222202220222222220000000000000000000000000000000000000000000000000
00022222222222222222022222022000222222202220222222022222220022222202202022222222000000000000000000000000000000000000000000000000
00002222222222222222202222220000222222222222222222022222222022222222022022222222000000000000000000000000000000000000000000000000
00000222222222222222222222200000222222222222222222222222220022222220220222222222000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222222222000000000000000000000000002222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000
02ffffffff220022200000000000000000002ffffffff22000000000000000000000000000000000000000000000000000000000000000000000000000000000
022f2f22f2f202ff2200000000000000000022f2f22f2f2000000000000000000000000000000000000000000000000000000000000000000000000000000000
002f2f22f2f202fff200000000000000000002f2f22f2f2000000000000000000000000000000000000000000000000000000000000000000000000000000000
002f2f22f2f202222200022222000222222002f2f22f2f2000222222000222220222002222200022222200222222220002222200000000000000000000000000
002f2f22f2f22ffff2002ffff2202fffff2202f2f22f2f2002fffff2202ffff22ff202ffff2002fffff222f2fffff2202ffff200000000000000000000000000
02ffffffff2022f2f202f2f22f22f2f222f22ffffffff22002222f2f2022f2f22f202f2f22202f2f222f222f2f222f22f2f22200000000000000000000000000
022fff22220002fff202fff22222fff202f222fff22fff2002ffffff2002fff22f2022ffff222fffffff202fff2022022ffff220000000000000000000000000
002fff22000002fff222fff22f22fff222f202fff22fff222f222fff2202fff22f200222fff22fff2222002fff200000222fff20000000000000000000000000
02fffff200002fffff222ffff2022fffff202ffff22ffff222fffff2f2022ffff2002fffff2022fffff202ffff200002fffff200000000000000000000000000
02222220000022222200222220002222220022222022222002222222200022222000222222000222222002222200000222222000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000022222222222200000000022000022222200222022202222220000220000222220002222220002222220022222000022202220000002220022000000000
00000222222222222220000000222000222002220222022222200222002220002220002022200222022200222222000200022202220000000222020000000000
00002222222222222222000002222000222002220222022222200222022220002220000022200222022200222222000000022202220000000022200000000000
00022222222222222222200000222000000002222220022222200222002220002220000000000222000000222222000000222002220000000202220000000000
00222222222222222222220000222000002222202220022202222220002220002222222000022220000222220222222200222002220000002200222000000000
02222222222222222222222000222000022000000222222222200222002220002220022200000222002200000222002220022222220000000000000000000000
02222222222222220022222000222000222002220000022222200222002220002220022222200222022200222222002220000002220000000000000000000000
02222200002222200002222200222000222002220000022222200222002220002220022222200222022200222222002220000002220000000000000000000000
22222200000222200000222222222220222222220000022202222220222222200222222002222220022222222022222200000002220000000000000000000000
22222000000222200000222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222000000222220000022200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22220000000222220000022200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22220000002222222000022200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222000022222222200222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222200022222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02222222222222022222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222222222202022222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00022222222002002222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00002222222002002222220000002222222000000000000000000000000000000000000000002222220000000000000000000000000000000000000000000000
0000022222200222222222000002ffffff220000000000000000000000000000000000000002fffff22000000000000000000000000000000000000000000000
000000022222222222222000002ff222f2f2000000000000000000000000000000000000002ff222ff2200000000000000000000000000000000000000000000
00000002222222222222000002f2f202fff200000000000000000000000000000000000002f2f202f2f200000000000000000000000000000000000000000000
00000002222222222222000002f2f202222000222222000222222222200022222200000002f2f202f2f202222022200222222002222222200000000000000000
00000002220202020220000002f2f222222202fffff2202fff2ff2ff2202fffff220000002f2f202f2f22fff22ff202fffff222f2fffff220000000000000000
00000000220202020020000002fff2fffff202222f2f2022f2f22f22f22f2f222f20000002fff202fff222f2f2f202f2f222f222f2f222f20000000000000000
00000000000000000000000002fff222fff202ffffff2002fff22f22f22fffffff20000002fff202fff202fff2f202fffffff202fff202200000000000000000
000000000000202020200000022ff222fff22f222fff2202fff22f22f22fff2222000000022ff222ff20022fff2002fff2222002fff200000000000000000000
0000000000202000000000000022ffffff2022fffff2f22ffff22f22f222fffff20000000022fffff200002fff20022fffff202ffff200000000000000000000
00000000000000022220000000022222220002222222202222202202200222222000000000022222200000222200002222220022222000000000000000000000
00000000002222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000002222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000022222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
