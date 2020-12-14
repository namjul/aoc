local utils = require('utils')
local inspect = require('inspect')

-- run `lua ./day14.lua`

local MASK_LENGTH = 36

local program = {}
local mask

local function genStringNumber(len)
  local str = '1'
  for _ = 1,len do
    str = str..'0'
  end
  return str
end

for line in utils.day(14) do
  if string.match(line, 'mask') then
    mask = utils.trim(({utils.split(line, '=')})[2])
  else
    local address, value = string.match(line, '%[(%d+)%] = (%d+)')
    local index = 1
    for c in string.gmatch(mask, '.') do
      if c ~= 'X' then
        local m = tonumber(genStringNumber(MASK_LENGTH - index), 2)
        if c == '1' then
          value = value | m
        elseif c == '0' then
          value = value & ~m
        end
      end
      index = index + 1
    end
    program[address] = value
  end
end

print(utils.reduce(program, function (acc, current)
  return acc + current
end, 0))
