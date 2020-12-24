local utils = require('utils')
local inspect = require('inspect')

local tiles = {}

local paths = {}

for line in utils.day(24) do
  local index = 1
  local path = {}
  for m in line:gmatch('.') do
    if #path > 0 then
      local prevC = path[#path]
      if (m == 'e' or m == 'w') and (prevC == 's' or prevC == 'n') then
        path[#path] = prevC..m
      else
        table.insert(path, m)
      end
    else
      table.insert(path, m)
    end
    index = index + 1
  end
  table.insert(paths, path)
end

-- print(inspect(paths[1]))

local directions = {
  e = {1,0},
  se = {0,1},
  sw = {-1,1},
  w = {-1,0},
  nw = {0,-1},
  ne = {1,-1}
}

local function hash(v)
  return v[1]..':'..v[2]
end

for _, path in ipairs(paths) do

  local reference = {0, 0}
  for i=1,#path do
    local direction = path[i]
    local q, r  = table.unpack(directions[direction])
    reference = {reference[1]+q, reference[2]+r}
  end

  local hashKey = hash(reference)
  if tiles[hashKey] == nil then
    tiles[hashKey] = true
  else
    tiles[hashKey] = nil
  end
end

local function unhash(v)
  local q, r = utils.split(v, ':')
  return { tonumber(q), tonumber(r) }
end

-- part1
-- print(inspect(utils.len(tiles)))

local checked = {}
local function checkCoordinate(coordinateKey, result)
  if not checked[coordinateKey] then
    -- print(coordinateKey)
    checked[coordinateKey] = true
  else
    -- print('already checked', coordinateKey)
  end
  local coordinate = unhash(coordinateKey)
  -- check neighbors for coordinate
  local neighbors = utils.map(directions, function(direction)
    return hash({coordinate[1] + direction[1], coordinate[2] + direction[2]})
  end)

  local blackNeighbors = utils.filter(neighbors, function(neighbor)
    return tiles[neighbor]
  end)

  local whiteNeighbors = utils.filter(neighbors, function(neighbor)
    return tiles[neighbor] == nil
  end)

  if coordinateKey == '-2:0' then
    -- print('blackNeighbors', coordinateKey, tiles[coordinateKey] and 'black' or 'white', inspect(blackNeighbors), #blackNeighbors)
  end

  if tiles[coordinateKey] then
    -- black
    if #blackNeighbors == 0 or #blackNeighbors > 2 then
      -- print('black to white')
      result[coordinateKey] = nil
    else
      result[coordinateKey] = true
    end
  else
    -- white
    if #blackNeighbors == 2 then
      -- print('white to black')
      result[coordinateKey] = true
    else
      result[coordinateKey] = nil
    end
  end
end

for _=1,100 do -- run days
  local newTiles = {}
  for coordinateKey in pairs(tiles) do
    checkCoordinate(coordinateKey, newTiles)

    -- check neighbors
    local coordinate = unhash(coordinateKey)
    local neighbors = utils.map(directions, function(direction)
      return hash({coordinate[1] + direction[1], coordinate[2] + direction[2]})
    end)
    for _, neighborKey in pairs(neighbors) do
        checkCoordinate(neighborKey, newTiles)
    end
  end
  tiles = newTiles
  print('Day '.._..':', inspect(#utils.filter(tiles, function(value) return value end)))
end

print('endresult: ', inspect(#utils.filter(tiles, function(value) return value end)))
