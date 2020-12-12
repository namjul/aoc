local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day12.lua ./day12-input.txt`

local instructions = {}
local file = assert(io.open(arg[1]))
for line in file:lines() do
  table.insert(instructions, line)
end
file:close()

local coordinate = { E = 0, N = 0 }
local directions = {'N','E','S','W'}
local direction = 2

for _,instruction in ipairs(instructions) do
  local action, value = string.match(instruction, '(%a)(%d+)')
  print(action, value, instruction)

  if action == 'N' then
    coordinate['N'] = coordinate['N'] + value
  elseif action == 'S' then
    coordinate['N'] = coordinate['N'] - value
  elseif action == 'E' then
    coordinate['E'] = coordinate['E'] + value
  elseif action == 'W' then
    coordinate['E'] = coordinate['E'] - value
  elseif action == 'L' then
    direction = (direction - value / 90) % #directions
    direction = direction == 0 and #directions or direction
  elseif action == 'R' then
    direction = math.floor((direction + value / 90) % #directions)
    direction = direction == 0 and #directions or direction
  elseif action == 'F' then
    local fDirection = directions[direction]
    if fDirection == 'N' or fDirection == 'E' then
      coordinate[fDirection] = coordinate[fDirection] + value
    elseif fDirection == 'S' then
      coordinate['N'] = coordinate['N'] - value
    elseif fDirection == 'W' then
      coordinate['E'] = coordinate['E'] - value
    end
  end
  -- print(inspect(coordinate), directions[direction])
end

print(math.abs(coordinate['E']) + math.abs(coordinate['N']))


