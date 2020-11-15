pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
#include particles.p8

#include ui.p8
#include levels.p8
#include game.p8
#include ship.p8
#include blackhole.p8
#include spaceman.p8

#include rotate_sprite.p8


#include debug.p8

left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15


#include game.p8
#include ship.p8

function _init()
  init_sprite(1, "plr")
  init_sprite(2, "spaceman")
  goto_splash()
end

function _update60()
  _upd()
end

function _draw()
  _drw()
  draw_debug()
end

__gfx__
02000000000dd0000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
18000000000dd0000000c60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2900000000d22d000006660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
da00000000dccd000066610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
670000000d5665d00666100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cb0000000d5665d00600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000d5665d00100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000d0000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000002222222222222200222222220022222222222222000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000020000000000020022000000002200000101010102200000000000
00000000000000000000000000000000000000000000000000000000000000000000000000200000202020202200000000000022000010101010220000000000
00000000000000000000000000000000000000000000000000000000000000000000000002000002020202220000000000000000220000000101022000000000
00000000000000000000000000000000000000000000000000000000000000000000000002000020202022000000000000000000002000000010102000000000
00000000000000000000000000000000000000000000000000000000000000000000000002000002020220000000022222200000000200000001012000000000
00000000000000000000000000000000000000000000000000000000000000000000000002000020202200000222200101022220000020000000102000000000
00000000000000000000000000000000000000000000000000000000000000000000000002000202022000222000000001010101220002000001012000000000
00000000000000000000000000000000000000000000000000000000000000000000000002000020220022000000000000010101022200200000102000000000
00000000000000000000000000000000000000000000000000000000000000000000000002000202020200000000000000000101010120200000012000000000
00000000000000000000000000000000000000000000000000000000000000000000000020000020202000000000000000000001010102020000102200000000
00000000000000000000000000000000000000000000000000000000000000000000000020000200220000000000000000000001010101220000010200000000
0000000000000000000000000000000000000000000000000000000000000000000000002000202220000000dd00000000000000010101022000001200000000
00000000000000000000000000000000000000000000000000000000000000000000000020000202000000dd0000000000000000010101022000010200000000
0000000000000000000000000000000000000000000000000000000000000000000000002000200200000d000000000000000000000101012000001200000000
0000000000000000000000000000000000000000000000000000000000000000000000002000022000000d000000000000000000000001010200010200000000
000000000000000000000000000000000000000000000000000000000000000000000000200020200000d0000000000000000000000001010200001200000000
000000000000000000000000000000000000000000000000000000000000000000000000200002200000d0000000000000000000000000010200010200000000
00000000000000000000000000000000000000000000000000000000000000000000000020002020000000000000000000000000000000010200001200000000
00000000000000000000000000000000000000000000000000000000000000000000000020000220000000000000000000000000000000010200000200000000
00000000000000000000000000000000000000000000000000000000000000000000000222002020000000000000000000000000000000010200001200000000
00000000000000000000000000000000000000000000000000000000000000000000022000200220000000000000000000000000000000010200010200000000
00000000000000000000000000000000000000000000000000000000000000000000200222002020000000000000000000000000000000010200002200000000
00000000000000000000000000000000000000000000000000000000000000000002002002000220000000000000000000000000000000010200012000000000
00000000000000000000000000000000000000000000000000000000000000000020020002002020000000000000000000000000000000010200102000000000
00000000000000000000000000000000000000000000000000000000000000000020200002000202000000000000000000000000000000012000012000000000
00000000000000000000000000000000000000000000000000000000000000000020200002002002000000000000000000000000000000012000102000000000
00000000000000000000000000000000000000000000000000000000000000000020200002000202000000000000000000000000000001022000012000000000
00000000000000000000000000000000000000000000000000000000000000000020200002000020200000000000000000000000000001020000102000000000
00000000000000000000000000000000000000000000000000000000000000000002020002000202200000000000000000000000000101020000012000000000
00000000000000000000000000000000000000000000000000000000000000000002020002000020220000000000000000000000000101220000102000000000
00000000000000000000000000000000000000000000000000000000000000000002020002000202020000000000000000000000000101200000012000000000
00000000000000000000000000000000000000000000000000000000000000000000202002000020202000000000000000000000010102000000102000000000
00000000000000000000000000000000000000000000000000000000000000000000202002000202022200000000000000000000010122200000012000000000
00000000000000000000000000000000000000000000000000000000000000000000020202000222200020000000000000000001010220222220102000000000
00000000000000000000000000000000000000000000000000000000000000000000002022222000000002000000000000000101022201010102222000000000
00000000000000000000000000000000000000000000000000000000000000000000000222000000000000220000000000010101222010101010102200000000
00000000000000000000000000000000000000000000000000000000000000000000002200000000000000002200000000010122010101010101010222000000
00000000000000000000000000000000000000000000000000000000000000000000220000000000000000000022000001012220100000001010101010220000
00000000000000000000000000000000000000000000000000000000000000000002020200000000000000000000222222220000000000000001010101002000
00000000000000000000000000000000000000000000000000000000000000000002202020000000000000000000000000000000000000000000101010102000
00000000000000000000000000000000000000000000000000000000000000000020022202000000000000000000000000000000000000000000000101022200
00000000000000000000000000000000000000000000000000000000000000000020000220200000000000000000000000000000000000000000000010120200
00000000000000000000000000000000000000000000000000000000000000000020000002020000000000000000000000000000000000000000000002020200
00000000000000000000000000000000000000000000000000000000000000000020000000202000000000000000000000000000000000000000000020202200
00000000000000000000000000000000000000000000000000000000000000000200000000020200000000000022222222222200000000000000002202020020
00000000000000000000000000000000000000000000000000000000000000000200000000002000000000000200000020000022000000000000022020202020
00000000000000000000000000000000000000000000000000000000000000000200000000020200000000000200000020000000200000000000220200000020
00000000000000000000000000000000000000000000000000000000000000000200000000002020000000002000000020000000200000000002202000002020
00000000000000000000000000000000000000000000000000000000000000000200000000020202000000002000000020000000200000000102020000020020
00000000000000000000000000000000000000000000000000000000000000000202000000002022000000002000000020000000200000001012000000200020
00000000000000000000000000000000000000000000000000000000000000000200200000020202000000002000000002000000200000000102000000000020
00000000000000000000000000000000000000000000000000000000000000000200020000202022000000002000000002000000200000001012000000020020
00000000000000000000000000000000000000000000000000000000000000000200002000020202000000002000000002000000200000000102000000002020
00000000000000000000000000000000000000000000000000000000000000000200000000202022000000002000000002000000200000001012000000000020
00000000000000000000000000000000000000000000000000000000000000000200000000020202000000002000000002000000200000000102000000000020
0000000000d11111111111111d00000000000000001111111111111111111111d0000000000000000d1111111111111111111111111111111110000000000000
0000000000d000000000000000d000000000000000100000000000000000000d00000000000000001d0000000000000000000000000000000010000000000000
0000000000d0000000000000000d0000000000000001000000000000000000d000000000000000010d0000000000000000000000000000000010000000000000
0000000000d00000000000000000d00000000000000010000000000000000d0000000000000000100d0000000000000000000000000000000010000000000000
0000000000d000000000000000000d000000000000000100000000000000d00000000000000001000d0000000000000000000000000000000010000000000000
0000000000d0000000000000000000d0000000000000001000000000000d000000000000000010000d0000000000000000000000000000000010000000000000
0000000000d00000000000000000000d00000000000000010000000000d0000000000000000100000d0000000000000000000000000000000010000000000000
0000000000d000000000000000000000d000000000000000100000000d00000000000000001000000d0000000000000000000000000000000010000000000000
0000000000d0000000000011111111111d0000000000000001000000d000000000000000010000000ddddddddddddd0000000001111111111110000000000000
0000000000d00000000000100000000000000000000000000010000d0000000000000000100000000000000000000d0000000001000000000000000000000000
0000000000d0000000000010000000000000000000000000000100d00000000000000001000000000111111111110d0000000001000000000000000000000000
0000000000d000000000001000000000000000000000000000001d000000000000000010000000000d00000000010d0000000001000000000000000000000000
0000000000d0000000000010000000000000000000000000000000000000000000000100000000000d00000000010d0000000001000000000000000000000000
0000000000d000000000001111111111111111d000000000000000000000000000001000000000000d00000000010d0000000001000000000000000000000000
0000000000d0000000000000000000000000000d00000000000000000000000000010000000000000d00000000010d0000000001000000000000000000000000
0000000000d00000000000000000000000000000d0000000000000000000000000100000000000000d00000000010d0000000001000000000000000000000000
0000000000d000000000000000000000000000000d000000000000000000000001000000000000000d00000000010d0000000001000000000000000000000000
0000000000d00000000000000000000000000000d0000000000000000000000000100000000000000d00000000010d0000000001000000000000000000000000
0000000000d0000000000000000000000000000d00000000000000000000000000010000000000000d00000000010d0000000001000000000000000000000000
0000000000d000000000001111111111111111d000000000000000000000000000001000000000000d00000000010d0000000001000000000000000000000000
0000000000d0000000000010000000000000000000000000000000000000000000000100000000000d00000000010d0000000001000000000000000000000000
0000000000d000000000001000000000000000000000000000001d000000000000000010000000000d00000000010d0000000001000000000000000000000000
0000000000d0000000000010000000000000000000000000000100d00000000000000001000000000d00000000010d0000000001000000000000000000000000
0000000000d00000000000100000000000000000000000000010000d0000000000000000100000000d00000000010d0000000001000000000000000000000000
0000000000d0000000000011111111111d0000000000000001000000d000000000000000010000000d00000000010d0000000001000000000000000000000000
0000000000d000000000000000000000d000000000000000100000000d00000000000000001000000d00000000010d0000000001000000000000000000000000
0000000000d00000000000000000000d00000000000000010000000000d0000000000000000100000d00000000010d0000000001000000000000000000000000
0000000000d0000000000000000000d0000000000000001000000000000d000000000000000010000d00000000010d0000000001000000000000000000000000
0000000000d000000000000000000d000000000000000100000000000000d00000000000000001000d00000000010d0000000001011101010110000000000000
0000000000d00000000000000000d00000000000000010000000000000000d0000000000000000100d00000000010d0000000001001001110100000000000000
0000000000dddddddddddddddddd0000000000000001111111111111111111d000000000000000011d00000000010d1111111111001001010110000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000d0000000001000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000d0000000001000000000000000000000000000000000000
00000000000d000000000000100000000d000000000001000000000ddd00000000111000000000000d00000000010d0000000000000000010000000000000000
000000000011d0000000000001000000d000000000001111111111d00000000000000111111111111d00000000010d0000000000000000001111000000000000
000000000000d0000000000001000000d0000000000010000000dd000000000000000011000000000d00000000010d0000000000000000000100000000000000
000000000111d000000000000010000d0000000000001111111d00000000000000000000111111111d00000000010d0000000000000000000011110000000000
0000000000000d00000000000010000d000000000001000000d000000000000000000000010000000d00000000010d0000000000000000000010000000000000
0000000011111d00000000000010000d00000000000111111d0000000000000000000000001111111d00000000010d0000000d11100000000011111110000000
0000000000000d0000000000000100d000000000000100000d0000000000000000000000001000000d00000000010d0000000d00010000000010000000000000
00000011111111d000000000000100d00000000000111111d00000000000000000000000000111111d00000000010d0000000d11110000000011111111100000
00000000000000d00000000000001d00000000000010000d000000000000000000000000000010000d00000000010d0000000d00010000000010000000000000
000011111111111d0000000000001d00000000000111111d000000000000000000000000000011111d00000000010d0000000d11110000000011111111111000
000000000000000d0000000000000000000000000100000d000000000000000000000000000010000d00000000010d0000000d00010000000010000000000000
001111111111111d000000000000000000000000011111d0000000000000000000000000000001111d00000000010d0000000d11110000000011111111111100
0000000000000000d00000000000000000000000100000d0000000000000000000000000000001000d00000000010d0000000d00010000000010000000000000
0111111111111111d00000000000000000000000111111d0000000000000000000000000000001111d00000000010d0000000d11110000000011111111111110
0000000000000000d00000000000000000000000100000d0000000000000000000000000000001000d00000000010d0000000d00010000000010000000000000
11111111111111111d0000000000000000000001111111d0000000000000000000000000000001111d00000000010d0000000d11110000000011111111111111
00000000000000000d0000000000000000000001000000d0000000000000000000000000000001000d00000000010d0000000d00010000000010000000000000
00001111111111111d0000000000000000000001111111d0000000000000000000000000000001111d00000000010d0000000d11110000000011111111111100
000000000000000000d000000000000000000010000000d0000000000000000000000000000001000d00000000010d0000000d00010000000010000000000000
000000111111111111d0000000000000000000111111111d000000000000000000000000000011111d00000000010d0000000d11110000000011111111111000
000000000000000000d0000000000000000000100000000d000000000000000000000000000010000d00000000010d0000000d00010000000010000000000000
0000000011111111111d000000000000000001111111111d000000000000000000000000000011111ddddddddddd0d0000000d11110000000011111111000000
0000000000000000000d0000000000000000010000000000d00000000000000000000000000100000000000000000d0000000d00010000000010000000000000
00000000000011111111d0000000000000001111111111111d0000000000000000000000001111111d11111111111d0000000dddd00000000011111100000000
00000000000000000000d0000000000000001000000000000d0000000000000000000000001000000d0000000000000000000000000000000010000000000000
00000000000000001111d00000000000000011111111111111d000000000000000000000011111111d0000000000000000000000000000000011110000000000
000000000000000000000d00000000000001000000000000000d00000000000000000000100000000d0000000000000000000000000000000010000000000000
000000000000000000111d000000000000011111111111111111dd000000000000000011111111111d0000000000000000000000000000000111000000000000
000000000000000000000d00000000000001000000000000000000d00000000000000100000000000d0000000000000000000000000000001000000000000000
0000000000000000000000d00000000000111111111111111111111ddd00000000111111111111111d0000000000000000000000000000011110000000000000
