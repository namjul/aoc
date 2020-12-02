-- run `lua ./day2.lua ./day2-input.txt`

local function split(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local result = {}
  for str in string.gmatch(inputstr, '([^'..sep..']+)') do
    table.insert(result, str)
  end
  return table.unpack(result)
end

local function trim(inputstr)
  return string.gsub(inputstr, '%s+', '')
end

local function parse(input)
  local policy, password = split(input, ':')
  local range, character = split(policy)
  local lower, upper = split(range, '-')
  return {tonumber(lower), tonumber(upper), character, trim(password)}
end

local function valid1(input)
  local lower, upper, character, password = table.unpack(input)
  local _, count = string.gsub(password, character, '')

  if count >= lower and count <= upper then
    return true
  end

  return false
end

local function valid2(input)
  local lower, upper, character, password = table.unpack(input)
  local subject = password:sub(lower, lower)..password:sub(upper, upper)
  local _, count = string.gsub(subject, character, '')

  if count == 1 then
    return true
  end

  return false
end

local file = assert(io.open(arg[1]))
local lines = {}
for x in file:lines() do lines[#lines+1] = parse(x) end
file:close()

local count = 0
for _, line in ipairs(lines) do
  if valid2(line) then
    count = count + 1
  end
end
print(count)
