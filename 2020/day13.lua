local utils = require('utils')
local inspect = require('inspect')

-- run `lua ./day13.lua`

local iterator = utils.day(13)
local timestamp = tonumber(iterator())
local busIds = {utils.split(iterator(), ',')}
local busIdsWithoutX = utils.filter(busIds, function (value) return value ~= 'x' end)

print(timestamp)
print(inspect(busIds))
print('--')

local function departureTime()
  local times = {}
  for _, busId in ipairs(busIdsWithoutX) do
    table.insert(times, math.ceil(timestamp / tonumber(busId)) * tonumber(busId))
  end

  local index={}
  for k,v in ipairs(times) do
    index[v]=k
  end
  return math.min(table.unpack(times)), index
end

-- part1
local minDepartedTime, lookup = departureTime()
local waitingTime = minDepartedTime - timestamp
print(waitingTime * busIdsWithoutX[lookup[minDepartedTime]])

-- part2

local function earliestTime(list)
  local time = 0
  while true do
    local count = 0
    for index, busId in ipairs(list) do
      if busId ~= 'x' then
        local minute = index - 1
        if (time + minute) % tonumber(busId) == 0 then
          count = count + 1
        else
          break
        end
      end
    end

    if count >= #utils.filter(list, function (value) return value ~= 'x' end) then
      return time
    end

    time = time + list[1]
  end
end

print(earliestTime(busIds))
