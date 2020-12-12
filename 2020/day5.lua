local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day5.lua`

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


local seats = {}

local highestId = 0
for line in utils.day(5) do
  local rowInput = string.sub(line, 1, 7)
  local colInput = string.sub(line, 8, 10)

  local row = search(rowInput, {0,127})
  local col = search(colInput, {0,7})

  seats[row..':'..col] = true

  local id = row * 8 + col

  if id > highestId then
    highestId = id
  end
end

for index=0,127,1 do
  for j=0,7,1 do
    if not seats[index..':'..j] then
      print(index, j)
    end
  end
end

print('--')
-- print(inspect(seats))
-- print(highestId)
