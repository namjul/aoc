local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day6.lua ./day6-input.txt`

local file = assert(io.open(arg[1]))

-- local function intersection(t1, t2)
--   local i = 1
--   local j = 1
--   local result = {}
--   while i < #t1 and j < #t2 do
--     if t1[i] == t2[j] then
--       table.insert(result, t2[j])
--       i = i + 1
--       j = j + 1
--   end
-- end

local groups = {}
local groupId = 1
local personId = 1

for x in file:lines() do
  for character in string.gmatch(x, '.') do
    local group = groups[groupId] or { amount = 0 }
    local characterGroup = group['character'] or { }

    characterGroup[character] = (characterGroup[character] or 0) + 1

    group['amount'] = personId
    group['character'] = characterGroup

    groups[groupId] = group
  end

  personId = personId + 1

  if x == '' then
    groupId = groupId + 1
    personId = 1
  end
end

print(inspect(groups))

local result = 0
for _,group in ipairs(groups) do
  local groupResult = 0
  for character,amount in pairs(group.character) do
    if amount == group.amount then
      groupResult = groupResult + 1
    end
  end

  result = groupResult + result
end

print('--')
print(result)


-- part 1
-- local result = 0
-- for _,group in ipairs(groups) do
--   local count = 0
--   for _ in pairs(group) do
--     count = count + 1
--   end
--   result = result + count
-- end

-- print(result)
