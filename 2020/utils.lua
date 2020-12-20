local inspect = require('inspect')
local utils =  {}

function utils.split(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local result = {}
  for str in string.gmatch(inputstr, '([^'..sep..']+)') do
    table.insert(result, str)
  end
  return table.unpack(result)
end

function utils.clone(t)
  if type(t) ~= 'table' then return t end
  local res = {}
  for k, v in pairs(t) do res[utils.clone(k)] = utils.clone(v) end
  return res
end

function utils.reduce(list, fn, initial)
  local acc = initial or list[1]
  for key, value in pairs(initial and list or utils.tail(list)) do
    acc = fn(acc, value, key, list)
  end
  return acc
end

function utils.map(list, fn)
  local result = {}
  for key, value in pairs(list) do
    table.insert(result, fn(value, key, list))
  end
  return result
end

function utils.filter(list, fn)
  local result = {}
  for key, value in pairs(list) do
    if fn(value, key, list) then
      table.insert(result, value)
    end
  end
  return result
end

function utils.sum(list)
  return utils.reduce(list, function (a, b) return a + b end)
end

function utils.every(list, fn)
  for key,value in pairs(list) do
    if not fn(value, key, list) then
      return false
    end
  end
  return true
end

function utils.partition(list, fn)
  local part1 = {}
  local part2 = {}

  for key, value in pairs(list) do
    if fn(value, key) then
      part1[key] = value
    else
      part2[key] = value
    end
  end

  return part1, part2
end

function utils.len(list)
  local count = 0
  for _, _ in pairs(list) do
    count = count + 1
  end
  return count
end

function utils.keys(list)
  local keys = {}
  for key, _ in pairs(list) do
    table.insert(keys, key)
  end
  return keys
end

function utils.values(list)
  local values = {}
  for _, value in pairs(list) do
    table.insert(values, value)
  end
  return values
end

function utils.day(day)
  local file = assert(io.open('day'..day..'-input.txt'))
  return function()
    local line = file:read()
    if line then
      return line
    else
      file:close()
      return nil
    end
  end
end

function utils.trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function utils.empty(list)
  return utils.len(list) == 0
end

function utils.forEach(list, fn)
  for key, value in pairs(list) do
      fn(value, key, list)
  end
end

function utils.tail(list)
  return {table.unpack(list, 2, #list)}
end

function utils.difference(list1, list2)
  local result = {}
  for key, value1 in pairs(list1) do
    -- if value1 is not in list2
    local found = false
    for _, value2 in pairs(list2) do
      if value1 == value2 then
        found = true
      end
    end
    if not found then
      table.insert(result, value1)
      -- result[key] = value1
    end
  end
  return result
end

function utils.merge(list1, list2)
  for key, value in pairs(list2) do
    list1[key] = value
  end
  return list1
end

function utils.startsWith(str,start)
   return string.sub(str,1,string.len(start))==start
end

-- Combination without repetition
-- {1,2,3} => {1,2},{1,3},{2,3}
-- Meaning all combinations where order does not matter and do not repeat.
-- Numbers should be combined with themself and the reverse would result in the same value.
-- Inspiration: https://github.com/trekhleb/javascript-algorithms/blob/master/src/algorithms/sets/combinations/combineWithoutRepetitions.js
-- run `lua ./day1.lua ./day1-input.txt`

--- A function that returns all combinations without repetition
-- @tparam tab comboOptions
-- @tparam number comboLength
-- @treturn tab

function utils.combineWithoutRepetitions(comboOptions, comboLength)
  if comboLength == 1 then
    return utils.map(comboOptions, function (option) return {option} end)
  end

  local combos = {}

  utils.forEach(comboOptions, function (currentOption, currentIndex)
    local slicedTable = {table.unpack(comboOptions, currentIndex + 1, #comboOptions)}
    local smallerCombo = utils.combineWithoutRepetitions(slicedTable, comboLength - 1)

    utils.forEach(smallerCombo, function (value)
      local combo = {currentOption}
      if type(value) == 'string' then
        table.insert(combo, value)
      end
      if type(value) == 'table' then
        for i = 1, #value do
          table.insert(combo, value[i])
        end
      end

      table.insert(combos, combo)
    end)
  end)

  return combos
end

-- Permutatino with repetition

function utils.permutateWithRepetition(permutationOptions, permutationLength)
  permutationLength = permutationLength or #permutationOptions

  if permutationLength == 1 then
    return utils.map(permutationOptions, function (option) return {option} end)
  end

  local permutations = {}

  local smallerPermutations = utils.permutateWithRepetition(
    permutationOptions,
    permutationLength - 1
  )

  utils.forEach(permutationOptions, function (currentOption)
    utils.forEach(smallerPermutations, function (smallerPermutation)
      local permutation = {currentOption}
      if type(smallerPermutation) == 'string' then
        table.insert(permutation, smallerPermutation)
      end
      if type(smallerPermutation) == 'table' then
        utils.forEach(smallerPermutation, function (value)
          table.insert(permutation, value)
        end)
      end
      table.insert(permutations, permutation)
    end)
  end)

  return permutations
end

return utils
