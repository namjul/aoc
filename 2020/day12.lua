local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day12.lua ./day12-input.txt`

local instructions = {}
for line in utils.day(12) do
  table.insert(instructions, line)
end

local function part1()
  local posx = 0
  local posy = 0
  local directions = {'N','E','S','W'}
  local direction = 2

  for _,instruction in ipairs(instructions) do
    local action, value = string.match(instruction, '(%a)(%d+)')

    if action == 'N' then
      posy = posy + value
    elseif action == 'S' then
      posy = posy - value
    elseif action == 'E' then
      posx = posx + value
    elseif action == 'W' then
      posx = posx - value
    elseif action == 'L' then
      direction = (direction - value / 90) % #directions
      direction = direction == 0 and #directions or direction
    elseif action == 'R' then
      direction = math.floor((direction + value / 90) % #directions)
      direction = direction == 0 and #directions or direction
    elseif action == 'F' then
      if directions[direction] == 'N' then
        posy = posy + value
      elseif directions[direction] == 'E' then
        posx = posx + value
      elseif directions[direction] == 'S' then
        posy = posy - value
      elseif directions[direction] == 'W' then
        posx = posx - value
      end
    end
  end
  return posx, posy
end

local function part2()
  local posx = 0
  local posy = 0
  local wpx = 10
  local wpy = 1

  for _,instruction in ipairs(instructions) do
    local action, value = string.match(instruction, '(%a)(%d+)')

    if action == 'N' then
      wpy = wpy + value
    elseif action == 'S' then
      wpy = wpy - value
    elseif action == 'E' then
      wpx = wpx + value
    elseif action == 'W' then
      wpx = wpx - value
    elseif ({R90 = true, L270 = true})[instruction] then
      wpx, wpy = wpy, -wpx
    elseif ({R180 = true, L180 = true})[instruction] then
      wpx, wpy = -wpx, -wpy
    elseif ({R270 = true, L90 = true})[instruction] then
      wpx, wpy = -wpy, wpx
    elseif action == 'F' then
      posx = posx + wpx * value
      posy = posy + wpy * value
    end
  end

  return posx, posy
end


local posx1, posy1 = part1()
print(math.abs(posx1) + math.abs(posy1))

local posx2, posy2 = part2()
print(math.abs(posx2) + math.abs(posy2))
