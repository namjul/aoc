local utils = require('utils')
local inspect = require('inspect')

-- run `lua ./day13.lua`
-- https://www.youtube.com/watch?v=4_5mluiXF5I
-- https://github.com/trekhleb/javascript-algorithms/tree/master/src/algorithms/math/euclidean-algorithm

local iterator = utils.day(13)
local start = tonumber(iterator())
local buses = {utils.split(iterator(), ',')}

print(start)
print(inspect(buses), #buses)
print('--')

local function part1(list)
  local maxWaitTime, busToTake = 9999999, 0
  utils.forEach(list, function(bus)
    local timeToWait = bus - start % bus
    if timeToWait < maxWaitTime then
      maxWaitTime = timeToWait
      busToTake = bus
    end

  end)
  return maxWaitTime * busToTake
end

print((part1(utils.map(buses, function (value) return tonumber(value) end))))

local function part2(list)

  local listx = utils.filter(
    utils.map(
      list,
      function (value, index) return { index - 1, type(value) == 'number' and tonumber(value) or value } end
    ),
    function (value) return value[2] ~= 'x' end
  )

  local jump, time = 1, 0
  for _, bus in ipairs(listx) do
    local delta, busId = table.unpack(bus)
    while true do
      if (delta + time) % busId  == 0 then
        break
      end
      time = time + jump
    end
    jump = jump * busId
  end
  return ("%.f"):format(time)
end

print(part2(buses))
