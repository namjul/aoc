local inspect = require('inspect')

-- run `lua ./day10.lua ./day10-input.txt`

local file = assert(io.open(arg[1]))
local lines = {}
for line in file:lines() do
  table.insert(lines, tonumber(line))
end
file:close()

table.sort(lines, function(a,b)
  return a < b and true or false
end)
table.insert(lines, 1, 0)
table.insert(lines, lines[#lines] + 3)

print(inspect(lines))
print('--')

-- part1
local function calcDifferences()
  local differences = {}
  for index,value in ipairs(lines) do
      local difference = tostring(value - (lines[index - 1] or 0))
      differences[difference] = (differences[difference] or 0) + 1
  end

  print(inspect(differences), differences['1'] * differences['3'])
end
calcDifferences()

-- part2
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
