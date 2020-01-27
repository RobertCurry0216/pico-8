pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function clamp(lower, upper, value)
  if value < lower then return lower end
  if value > upper then return upper end
  return value
end