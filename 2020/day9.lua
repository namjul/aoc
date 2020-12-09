local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day9.lua ./day9-input.txt`

local file = assert(io.open(arg[1]))

local preamble = 25
local data = {}

for line in file:lines() do
  table.insert(data, line)
end

-- print(inspect(data))
print('--')

local invalidNum = nil

for index=1, #data do
  local num = tonumber(data[index])
  if index > preamble then
    local isValid = false
    local combinations = utils.combineWithoutRepetitions({table.unpack(data, index - preamble, index)}, 2)
    for _, value in ipairs(combinations) do
      if math.abs(tonumber(value[1]) + tonumber(value[2])) == num then
        isValid = true
      end
    end
    if not isValid then
      invalidNum = num
    end
  end
end

print('invalidNum: ', invalidNum)

local encryptionWeakness

for index=1, #data do
  local count = 1
  while data[index + count] ~= nil do
    local set = utils.map({table.unpack(data, index, index + count)}, function (v) return tonumber(v) end)
    local sum = utils.reduce(set, function (a, b) return a + b end)
    if sum > invalidNum then
      break
    end
    if sum == invalidNum then
      local min = math.min(table.unpack(set))
      local max = math.max(table.unpack(set))
      encryptionWeakness = min + max
      break
    end
    count = count + 1
  end
  if encryptionWeakness then
    print('encryption weakness: ', encryptionWeakness)
    break
  end
end

