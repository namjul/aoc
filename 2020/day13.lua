local utils = require('utils')
local inspect = require('inspect')

-- run `lua ./day13.lua`

local iterator = utils.day(13)
local timestamp = tonumber(iterator())
local busIds = utils.filter({utils.split(iterator(), ',')}, function (value) return value ~= 'x' end)

print(timestamp)
print(inspect(busIds))
print('--')

local function departureTime()
  local times = {}
  for _, busId in ipairs(busIds) do
    table.insert(times, math.ceil(timestamp / tonumber(busId)) * tonumber(busId))
  end

  local index={}
  for k,v in ipairs(times) do
    index[v]=k
  end
  return math.min(table.unpack(times)), index
end

local minDepartedTime, index = departureTime()
local waitingTime = minDepartedTime - timestamp

print(waitingTime * busIds[index[minDepartedTime]])
