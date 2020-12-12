local utils = require('utils')

local lines = {}
for x in utils.day(1) do lines[#lines+1] = x end

local combinations = utils.combineWithoutRepetitions(lines, 3)

print(#combinations)

for _, value in ipairs(combinations) do
  local sum = value[1] + value[2] + value[3]
  if sum == 2020 then
    print(value[1] , value[2] , value[3])
    print('Found', sum, value[1] * value[2] * value[3])
  end
end
