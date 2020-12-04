local inspect = require('inspect')
local utils = require('utils')
-- run `lua ./day4.lua ./day4-input.txt`

local file = assert(io.open(arg[1]))

local function parseLine(line)
  local result = {}
  for _, value in ipairs(table.pack(utils.split(line))) do
    local key, data = utils.split(value, ':')
    result[key] = data
  end
  return result
end

local function isValid(password)
  local valid = true
  local requiredFields = { byr = true, iyr = true, eyr  = true, hgt  = true, hcl  = true, ecl  = true, pid  = true, cid  = false }

  for key, value in pairs(requiredFields) do
    if value and password[key] == null then
      valid = false
    end
  end
  return valid
end

local passwords = {}
local index = 1

for x in file:lines() do

  if x == '' then
    index = index + 1
    print('\n')
  else

    local fields = parseLine(x)

    if passwords[index] == nil then
      passwords[index] = fields
    else
      for key, value in pairs(fields) do 
        passwords[index][key] = value
      end
    end

  end
end
file:close()

local countValid = 0
for _, value in ipairs(passwords) do
  if isValid(value) then
    countValid = countValid + 1
  end
end
print(countValid)
