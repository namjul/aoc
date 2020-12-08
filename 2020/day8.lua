local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day8.lua ./day8-input.txt`

local file = assert(io.open(arg[1]))
local commands = {}
for line in file:lines() do
  commands[#commands + 1] = {utils.split(line)}
end


local visited = {}

local index = 1
local acc = 0

local function run()
  local instruction = commands[index] or {}
  local command = instruction[1]
  local argument = instruction[2]
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

end

while visited[index] == nil do
  run()
end

print(acc)
