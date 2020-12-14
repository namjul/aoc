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
  local acc = initial
  for index, value in pairs(list) do
    if index == 1 then
      acc = value
    else
      acc = fn(acc, value, index)
    end
  end
  return acc
end

function utils.map(list, fn)
  local result = {}
  for index, value in ipairs(list) do
    table.insert(result, fn(value, index, list))
  end
  return result
end

function utils.filter(list, fn)
  local result = {}
  for index, value in pairs(list) do
    if fn(value, index, list) then
      table.insert(result, value)
    end
  end
  return result
end

function utils.sum(list)
  return utils.reduce(list, function (a, b) return a + b end)
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

function utils.forEach(list, fn)
  for currentIndex, currentValue in ipairs(list) do
      fn(currentValue, currentIndex)
  end
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
