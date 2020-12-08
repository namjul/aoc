local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day8.lua ./day8-input.txt`

local file = assert(io.open(arg[1]))
local commands = {}
for line in file:lines() do
  commands[#commands + 1] = {utils.split(line)}
end


local visited = {}

local function run(index)
  local instruction = commands[index]
  local command = instruction[1]
  local argument = instruction[2]
  local acc = 0

  if visited[index] ~= nil then
    return acc
  end

  visited[index] = true

  if command == 'acc' then
    acc = acc + tonumber(argument)
    index = index + 1
  end

  if command == 'nop' then
    index = index + 1
  end

  if command == 'jmp' then
    index = index + argument
  end

  return acc + run(index)
end

print('--')
print(run(1))
