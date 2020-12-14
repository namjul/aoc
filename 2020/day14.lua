local utils = require('utils')
local inspect = require('inspect')

-- run `lua ./day14.lua`

local function toBinary(num, bits)
  local result = ''
  while num > 0 do
    local rest = math.floor(num % 2)
    result = rest..result
    num = (num - rest) / 2
  end
  if bits then
    while string.len(result) < bits do
      result = '0'..result
    end
  end
  return result
end

local function genStringNumber(len)
  local str = '1'
  for _ = 1,len do
    str = str..'0'
  end
  return str
end

local function part1()
  local program = {}
  local mask

  for line in utils.day(14) do
    if string.match(line, 'mask') then
      mask = utils.trim(({utils.split(line, '=')})[2])
    else
      local address, value = string.match(line, '%[(%d+)%] = (%d+)')
      local index = 1
      for c in string.gmatch(mask, '.') do
        if c ~= 'X' then
          local m = tonumber(genStringNumber(#mask - index), 2)
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

  return program
end

local function part2()
  local program = {}
  local mask

  for line in utils.day(14) do
    if string.match(line, 'mask') then
      mask = utils.trim(({utils.split(line, '=')})[2])
    else
      local address, value = string.match(line, '%[(%d+)%] = (%d+)')
      local addressBinary = toBinary(tonumber(address), #mask)

      local result = ''
      for index = 1, #mask do
        local c = mask:sub(index, index)
        if c == 'X' then
          result = result..c
        elseif c == '1' then
          result = result..'1'
        elseif c == '0' then
          result = result..addressBinary:sub(index, index)
        end
      end
      local floatinBits = ({string.gsub(result, 'X', '')})[2]
      local floatinBitsMax = tonumber(genStringNumber(floatinBits), 2) - 1
      for i = 0, floatinBitsMax do
        local floatingBinary = toBinary(i, floatinBits)
        local counter = 0
        local newAddress = string.gsub(result, 'X', function ()
          counter = counter + 1
          return floatingBinary:sub(counter,counter)
        end)
        program[newAddress] = value
      end
    end
  end

  return program
end

print(utils.reduce(part1(), function (acc, current)
  return acc + current
end, 0))

print(utils.reduce(part2(), function (acc, current)
  return acc + current
end, 0))
