local inspect = require('inspect')
local utils = require('utils')
-- run `lua ./day4.lua`

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
  local requiredFields = { 'byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid' }

  local function isBetween(value, lower, upper)
    local valueAsNumber = tonumber(value)
    return valueAsNumber <= upper and valueAsNumber >= lower
  end

  for _, value in ipairs(requiredFields) do
    local pValue = password[value]
    if password[value] == nil then
      valid = false
    else
      if value == 'byr' then
        if not (string.match(password[value], '^%d%d%d%d$') and isBetween(password[value], 1920, 2002)) then
          valid = false
        end
      end

      if value == 'iyr' then
        if not (string.match(password[value], '^%d%d%d%d$') and isBetween(password[value], 2010, 2020)) then
          valid = false
        end
      end

      if value == 'eyr' then
        if not (string.match(password[value], '^%d%d%d%d$') and isBetween(password[value], 2020, 2030)) then
          valid = false
        end
      end

      if value == 'hgt' then
        local height, unit = string.match(pValue, '(%d+)(.*)')
        if unit == '' then
          valid = false
        end
        if unit == 'cm' and not isBetween(height, 150, 193) then
          valid = false
        end
        if unit == 'in' and not isBetween(height, 59, 76) then
          valid = false
        end
      end

      if value == 'hcl' then
          -- local digitHex = string.match(pValue, '^#%d%d%d%d%d%d$')
          -- local letterHex = string.match(pValue, '^#%a%a%a%a%a%a$')
          -- may %x is corrent
          local hex = string.match(pValue, '^#%x%x%x%x%x%x$')
          if not hex then
            valid = false
          end
      end

      if value == 'ecl' then
        local eyeColors = { amb = true, blu = true, brn = true, gry = true, grn = true, hzl = true, oth = true, }
        if eyeColors[pValue] == nil then
          valid = false
        end
      end

      if value == 'pid' then
        if not string.match(pValue, '^%d%d%d%d%d%d%d%d%d$') then
          valid = false
        end
      end
    end
  end
  return valid
end

local passwords = {}
local index = 1

for line in utils.day(4) do

  if line == '' then
    index = index + 1
    print('\n')
  else

    local fields = parseLine(line)

    if passwords[index] == nil then
      passwords[index] = fields
    else
      for key, value in pairs(fields) do
        passwords[index][key] = value
      end
    end

  end
end

local countValid = 0
for _, value in ipairs(passwords) do
  if isValid(value) then
    countValid = countValid + 1
  end
end
print(countValid)
