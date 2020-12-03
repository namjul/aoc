local inspect = require('inspect')

-- run `lua ./day3.lua ./day3-input.txt`

local file = assert(io.open(arg[1]))

local grid = {}
for x in file:lines() do
  local row = {}
  string.gsub(x, '.', function(character) table.insert(row, character) end)
  grid[#grid+1] = row
end
file:close()

local function reveal(location)
    local x = location[1]
    local y = location[2]
    local row = grid[y]

    if y > #grid then
      return nil
    end

    local index = x > #row and x % #row or x
    local sign = row[index == 0 and #row or index]
    return sign
end

local function traverse(movement)
  local right = movement[1]
  local down = movement[2]
  local currentLocation = {1,1}
  local countTrees = 0

  repeat
    currentLocation = {currentLocation[1] + right, currentLocation[2] + down}
    local sign = reveal(currentLocation)

    if sign == '#' then
      countTrees = countTrees + 1
    end
  until sign == nil

  return countTrees
end

print(traverse({1,1}) * traverse({3,1}) * traverse({5,1}) * traverse({7,1}) * traverse({1,2}))
