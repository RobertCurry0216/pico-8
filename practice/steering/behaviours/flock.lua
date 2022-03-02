vechicles = {}

function flock(vechicle)
  local neighbors = find_neighbors(vechicle, vechicles)
  local c = coherence(vechicle, neighbors) * 2
  local s = seperation(vechicle, neighbors)
  local a = alignment(vechicle, neighbors) * 3

  local steering = c + s + a
  steering:limit(vechicle.max_speed)
  return steering
end

function find_neighbors(vechicle, vechicles)
  local n = {}
  for v in all(vechicles) do
    local dist = v.pos - vechicle.pos
    if v != vechicle then
      if dist:magsq() < 400 then
        add(n, v)
      end
    end
  end
  return n
end

function coherence(vechicle, neighbors)
  local s = vector()
  if (#neighbors == 0) return s

  for v in all(neighbors) do
    s += v.pos
  end

  local target = (s / #neighbors) - vechicle.pos
  return target:norm()
end

function seperation(vechicle, neighbors)
  local s = vector()
  if (#neighbors == 0) return s

  for v in all(neighbors) do
    s -= (v.pos - vechicle.pos):norm()
  end

  return s
end

function alignment(vechicle, neighbors)
  local s = vector()
  if (#neighbors == 0) return s

  for v in all(neighbors) do
    s += v.vel
  end

  s = s / #neighbors

  return s / 8
end