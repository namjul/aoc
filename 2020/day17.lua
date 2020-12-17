local utils = require'utils'
local inspect = require'inspect'

-- run `lua ./day17-input.lua`

local function coordinateKey(...)
  return utils.reduce({...}, function (acc, current, index, src)
    acc = acc..current
    if index ~= #src then
      acc = acc..':'
    end
    return acc
  end, '')
end



local relativeNeighborsWithOrigin = utils.permutateWithRepetition({-1,0,1}, 4)
local relativeNeighbors = utils.filter(relativeNeighborsWithOrigin, function(neighbor)
  return coordinateKey(neighbor[1], neighbor[2], neighbor[3], neighbor[4]) ~= '0:0:0:0'
end)

local initialActiveCubes = {}
local y = 1

for line in utils.day(17) do
  local x = 1
  for p in line:gmatch('.') do
    if p == '#' then
      initialActiveCubes[coordinateKey(x, y, 0, 0)] = p
    end
    x = x + 1
  end
  y = y + 1
end

print(inspect(initialActiveCubes))
-- print(inspect(#relativeNeighborsWithOrigin))
print(inspect(relativeNeighbors))

local function getNeighbors(coordinate, withOrigin)
  withOrigin = withOrigin or false
  local x, y, z, w = utils.split(coordinate, ':')
  local rn = withOrigin and relativeNeighborsWithOrigin or relativeNeighbors
  return utils.map(rn, function (relativeNeighbor)
    local nox, noy, noz, now = table.unpack(relativeNeighbor)
    local nx, ny, nz, nw = math.ceil(x + nox), math.ceil(y + noy), math.ceil(z + noz), math.ceil(w + now)
    return coordinateKey(nx, ny, nz, nw)
  end)
end

local function countActiveNeighbors(neighbors, activeCubes)
  local count = 0
  for _, neighbor in ipairs(neighbors) do
    if activeCubes[neighbor] == '#' then
      count = count + 1
    end
  end
  return count
end

local function run(coordinates)
  local cubes = {}
  local nextCoordinates = {}
  for coordinate in pairs(coordinates) do
    for _, neighbor in ipairs(getNeighbors(coordinate, true)) do
      cubes[neighbor] = true
    end
  end

  for cube in pairs(cubes) do
    local neighborActiveCubes = countActiveNeighbors(getNeighbors(cube), coordinates)
    if coordinates[cube] == '#' then
      if neighborActiveCubes == 2 or neighborActiveCubes == 3 then
        nextCoordinates[cube] = '#'
      end
    else
      if neighborActiveCubes == 3 then
        nextCoordinates[cube] = '#'
      end
    end
  end
  return nextCoordinates
end

local function countActiveCubes(cubes)
  return #utils.filter(cubes, function (cube) return cube == '#' end)
end

local last = initialActiveCubes
for _ = 1,6 do
  last = run(last)
end
print(countActiveCubes(last))
