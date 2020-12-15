local utils = require('utils')
local inspect = require('inspect')

-- run `lua ./day15.lua`

-- example:
-- 0,3,6
-- 0,3,6,0,|3,3,1,0,4,0
-- 0:1,3:2,6:3,0:4,3:5,3:6,1:7,0:8,4:9,0:10
-- 0,3,6,(6->0),(0->3),(3->3),(3->1),(1->0),(0->4),(4->0)

local input = {6,13,1,15,2,0}
local max = 2020

local map = {}
utils.forEach({table.unpack(input, 1, #input - 1)}, function (value, index)
  map[value] = index
end)

local result = utils.clone(input)

for i = #input, max - 1 do
  local lastNumber = result[#result]

  if map[lastNumber] then
    local age = i - map[lastNumber]
    table.insert(result, age)
  else
    table.insert(result, 0)
  end

  map[result[#result - 1]] = i
end

print(result[#result])