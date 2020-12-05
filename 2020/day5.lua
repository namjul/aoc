local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day5.lua ./day5-input.txt`

local file = assert(io.open(arg[1]))

local function search(input, range)
  for index=1, #input do
    local character = string.sub(input, index, index)
    local half = (range[2] - range[1]) / 2

    if character == 'F' or character == 'L' then
      range[2] = range[1] + math.floor(half)
    end

    if character == 'B' or character == 'R' then
      range[1] = range[1] + math.ceil(half)
    end
  end
  return range[1]
end

local highest = 0
for x in file:lines() do
  local rowInput = string.sub(x, 1, 7)
  local colInput = string.sub(x, 8, 10)

  local result = search(rowInput, {0,127}) * 8 + search(colInput, {0,7})

  if result > highest then
    highest = result
  end
end

print(highest)

file:close()
