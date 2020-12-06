local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day6.lua ./day6-input.txt`

local file = assert(io.open(arg[1]))

local groups = {}

local groupId = 1

for x in file:lines() do
  for character in string.gmatch(x, '.') do
    local group = groups[groupId] or {}
    group[character] = true
    groups[groupId] = group
  end

  if x == '' then
    groupId = groupId + 1
  end
end

local result = 0
for _,group in ipairs(groups) do
  local count = 0
  for _ in pairs(group) do
    count = count + 1
  end
  result = result + count
end

print(result)
