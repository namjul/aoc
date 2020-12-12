local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day8.lua`

local instructions = {}
for line in utils.day(8) do
  table.insert(instructions, {utils.split(line)})
end

local function run(index, _instructions, visited)
  local instruction = _instructions[index]
  local acc = 0

  if instruction == nil then
    return acc, index, 'eof'
  end

  local command = instruction[1]
  local argument = instruction[2]

  if visited[index] ~= nil then
    return acc, index, 'loop'
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

  local _acc, _index, message = run(index, _instructions, visited)
  return acc + _acc, _index, message
end

print('--')

-- part1
-- print(run(1))

-- part2
for index = 1, #instructions do
  local instruction = instructions[index]
  local command = instruction[1]
  local argument = instruction[2]

  local copyInstructions = utils.clone(instructions)

  if command == 'nop' then
    copyInstructions[index] = { 'jmp', argument }
  end

  if command == 'jmp' then
    copyInstructions[index] = { 'nop', argument }
  end

  local _acc, _index, message = run(1, copyInstructions, {})
  if message == 'eof' then
    print(_acc)
    break
  end
end

