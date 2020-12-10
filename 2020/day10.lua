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
table.insert(lines, math.max(table.unpack(lines)) + 3)

print(inspect(lines))
print('--')

local differences = {}
for index,value in ipairs(lines) do
    local difference = tostring(value - (lines[index - 1] or 0))
    differences[difference] = (differences[difference] or 0) + 1
end

print(inspect(differences), differences['1'] * differences['3'])
