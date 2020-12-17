local utils = require'utils'
local inspect = require'inspect'

-- run `lua ./day16.lua`

local readline = utils.day(16)
local line = readline()

local fields = {}
while line and line ~= '' do
  local field, ranges = utils.split(line, ':')
  for range in ranges:gmatch('%d+-%d+') do
    local start, finish = range:match('(%d+)-(%d+)')
    for i=tonumber(start),tonumber(finish),1 do
      local set = fields[field] or {}
      set[i] = true
      fields[field] = set
    end
  end
  line = readline()
end
-- print(inspect(fields))

line = readline()
local tickets = {}
while line and line ~= '' do
  line = readline()
  for _, value in ipairs({utils.split(line, ',')}) do
    table.insert(tickets, tonumber(value))
  end
  line = readline()
end
-- print(inspect(tickets))

line = readline()
local nearbyTickets = {}
local unvalidTickes = {}
while line and line ~= '' do
  line = readline()
  if line then
    local values = {}
    for _,num in pairs({utils.split(line, ',')}) do
      local isValid = false
      for _,field in pairs(fields) do
        if field[tonumber(num)] then
          isValid = true
        end
      end
      if not isValid then
        table.insert(unvalidTickes, tonumber(num))
      else
        table.insert(values, tonumber(num))
      end
    end
    table.insert(nearbyTickets, values)
  end
end

-- print(utils.sum(unvalidTickes))
-- print(inspect(nearbyTickets))

local index = 1
local positions = {}
while nearbyTickets[index] do
  local field = {}
  for _, ticket in ipairs(nearbyTickets) do
    table.insert(field, ticket[index])
  end
  table.insert(positions, field)
  if index > #nearbyTickets[index] then
    break
  end
  index = index + 1
end

local positionsMapping = {}
for index, position in ipairs(positions) do
  local m = utils.partition(fields, function (set)
    return utils.every(
      position,
      function (value)
        return set[value]
      end
    )
  end)
  positionsMapping[utils.len(m)] = {index = index, fields = utils.keys(m)}
end

local function matching(list, taken, result)
  result = result or {}
  taken = taken or {}

  local first = list[1]

  local rest = utils.tail(list)
  local match = utils.difference(first['fields'], taken)
  result[first['index']] = table.unpack(match)

  if not utils.empty(rest) then
    return matching(rest, first['fields'], result)
  else
    return result
  end
end

local orderedFields = matching(positionsMapping)

local count = 1
for index, field in ipairs(orderedFields) do
  if utils.startsWith(field, 'departure') then
    count = count * tickets[index]
  end
end
print(count)
