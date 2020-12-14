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

  local combos = {}

  if comboLength == 1 then
    for index, value in ipairs(comboOptions) do
      combos[index] = value
    end
    return combos
  end

  for currentIndex, currentValue in ipairs(comboOptions) do
    local slicedTable = {table.unpack(comboOptions, currentIndex + 1, #comboOptions)}
    local smallerCombo = utils.combineWithoutRepetitions(slicedTable, comboLength - 1)

    for _, value in ipairs(smallerCombo) do
      local combo = {currentValue}
      if type(value) == 'string' then
        table.insert(combo, value)
      end
      if type(value) == 'table' then
        for i = 1, #value do
          table.insert(combo, value[i])
        end
      end

      table.insert(combos, combo)
    end
  end

  return combos
end

return utils
