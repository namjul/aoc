local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day12.lua ./day12-input.txt`

local instructions = {}
local file = assert(io.open(arg[1]))
for line in file:lines() do
  table.insert(instructions, line)
end
file:close()

function part1()
  local coordinate = { E = 0, N = 0 }
  local directions = {'N','E','S','W'}
  local direction = 2

  for _,instruction in ipairs(instructions) do
    local action, value = string.match(instruction, '(%a)(%d+)')
    -- print(action, value, instruction)

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
  return coordinate
end

local function part2()
  local coordinate = { x = 0, y = 0 }
  local waypoint = { x = 10, y = 1 }

  for _,instruction in ipairs(instructions) do
    local action, value = string.match(instruction, '(%a)(%d+)')
    print(action, value, instruction)

    if action == 'N' then
      waypoint['y'] = waypoint['y'] + value
    elseif action == 'S' then
      waypoint['y'] = waypoint['y'] - value
    elseif action == 'E' then
      waypoint['x'] = waypoint['x'] + value
    elseif action == 'W' then
      waypoint['x'] = waypoint['x'] - value
    elseif ({R90 = true, L270 = true})[instruction] then
      local cWaypoint = utils.clone(waypoint)
      waypoint['x'] = cWaypoint['y']
      waypoint['y'] = -cWaypoint['x']
    elseif ({R180 = true, L180 = true})[instruction] then
      waypoint['x'] = -waypoint['x']
      waypoint['y'] = -waypoint['y']
    elseif ({R270 = true, L90 = true})[instruction] then
      local cWaypoint = utils.clone(waypoint)
      waypoint['x'] = -cWaypoint['y']
      waypoint['y'] = cWaypoint['x']
    elseif action == 'F' then
      coordinate['x'] = coordinate['x'] + waypoint['x'] * value
      coordinate['y'] = coordinate['y'] + waypoint['y'] * value
    end

    -- print(inspect(waypoint))
  end

  return coordinate
end


local coordinate = part2()
print(inspect(coordinate))
print(math.abs(coordinate['x']) + math.abs(coordinate['y']))
