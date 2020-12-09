local utils = require('utils')


local file = assert(io.open(arg[1]))
local lines = {}
for x in file:lines() do lines[#lines+1] = x end
file:close()

local combinations = utils.combineWithoutRepetitions(lines, 3)

print(#combinations)

for _, value in ipairs(combinations) do
  local sum = value[1] + value[2] + value[3]
  if sum == 2020 then
    print(value[1] , value[2] , value[3])
    print('Found', sum, value[1] * value[2] * value[3])
  end
end
