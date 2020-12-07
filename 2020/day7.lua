local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day7.lua ./day7-input.txt`

-- data structure:
-- { 'light_red' = { 'bright_write' = 1, 'muted_yellow' = 2 } }
-- { 'dark_orange' = { 'bright_write' = 3, 'muted_yellow' = 4 } }
-- { 'bright_white' = { 'shiny_gold' = 1 } }
-- { 'muted yellow' = { 'shiny_gold' = 2, 'faded_blue' = 9 } }

local file = assert(io.open(arg[1]))

local lookupTable = {}

for x in file:lines() do
  local a, b = string.match(x, '([%a%s]+)%sbags%scontain(.*,*%.*)')

  local bag = {}

  for _,value in ipairs(table.pack(utils.split(b, ','))) do

    local c, d = string.match(value, '(%s%d%s)([%a%s]+)%sbags*')
    if c then
    bag[d] = c
    end
  end

  lookupTable[a] = bag

end

print(inspect(lookupTable))

local function checkShinyGold(name)
  local bag = lookupTable[name]
  for _name in pairs(bag) do
    if _name == 'shiny gold' then
      return true
    else
     local result = checkShinyGold(_name)
     if result then
       return true
     end
    end
  end
end

local count = 0
for name in pairs(lookupTable) do
  if (checkShinyGold(name)) then
    print(name)
    count = count + 1
  end
end
print(count)
