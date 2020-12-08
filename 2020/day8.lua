local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day8.lua ./day8-input.txt`

local file = assert(io.open(arg[1]))
local commands = {}
for line in file:lines() do
  table.insert(commands, {utils.split(line)})
end


local visited = {}

local function run(index)
  local instruction = commands[index]
  local acc = 0

  if instruction == nil then
    return acc, index
  end

  local command = instruction[1]
  local argument = instruction[2]

  if visited[index] ~= nil then
    return acc, index
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

  local _acc, _index = run(index)
  return acc + _acc, _index
end

print('--')

-- part1
-- print(run(1))

-- part2
for index = 1, #commands do
  local instruction = commands[index]
  local command = instruction[1]
  local argument = instruction[2]

  if command == 'nop' then
    commands[index] = {'jmp', argument}
    local _acc, _index = run(1)
    if _index == 648 then
      print(_acc)
    end
    commands[index] = instruction
    visited = {}
  end

  if command == 'jmp' then
    commands[index] = {'nop', argument}
    local _acc, _index = run(1)
    if _index == 648 then
      print(_acc)
    end
    commands[index] = instruction
    visited = {}
  end
end

