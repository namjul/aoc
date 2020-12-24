local utils = require('utils')
local inspect = require('inspect')

local blackTiles = {}

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

for _, path in ipairs(paths) do
  -- print(inspect(path))

  local reference = {0, 0}
  for i=1,#path do
    local direction = path[i]
    local q, r  = table.unpack(directions[direction])
    reference = {reference[1]+q, reference[2]+r}
  end

  local hashKey = reference[1]..':'..reference[2]
  if not blackTiles[hashKey] then
    blackTiles[hashKey] = true
  else
    blackTiles[hashKey] = false
  end
end

print(inspect(#utils.filter(blackTiles, function(value) return value end)))
