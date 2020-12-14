local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day10.lua`

local lines = {}
for line in utils.day(10) do
  table.insert(lines, tonumber(line))
end

table.sort(lines)

print(inspect(lines))
print('--')

-- part1
function calcDifferences()
  local differences = { 0, 0, 1 }
  local last = 0
  for _,value in ipairs(lines) do
    local difference = value - last
    differences[difference] = differences[difference] + 1
    last = value
  end

  print(inspect(differences), differences[1] * differences[3])
end
calcDifferences()

-- part2
table.insert(lines, 1, 0)
table.insert(lines, lines[#lines] + 3)
local cache = {}
local function countCombinations(from)
  if cache[from] then
    return cache[from]
  end
  local count = 0
  local next = from + 1

  while lines[next] and lines[next] - lines[from] <= 3 do
    count = count + countCombinations(next)
    next = next + 1
  end

  count = count == 0 and 1 or count

  cache[from] = count

  return count
end
print(inspect(countCombinations(1)))
