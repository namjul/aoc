

-- Combination without repetition
-- {1,2,3} => {1,2},{1,3},{2,3}
-- Meaning all combinations where order does not matter and do not repeat.
-- Numbers should be combined with themself and the reverse would result in the same value.
-- Inspiration: https://github.com/trekhleb/javascript-algorithms/blob/master/src/algorithms/sets/combinations/combineWithoutRepetitions.js

--- A function that returns all combinations without repetition
-- @tparam tab comboOptions
-- @tparam number comboLength
-- @treturn tab

local function combineWithoutRepetitions(comboOptions, comboLength)

  local combos = {}

  if comboLength == 1 then
    for index, value in ipairs(comboOptions) do
      combos[index] = value
    end
    return combos
  end

  for currentIndex, currentValue in ipairs(comboOptions) do
    local slicedTable = {table.unpack(comboOptions, currentIndex + 1, #comboOptions)}
    local smallerCombo = combineWithoutRepetitions(slicedTable, comboLength - 1)

    for index, value in ipairs(smallerCombo) do
      local combo = {currentValue}
      if type(value) == 'string' then
        table.insert(combo, value)
      end
      if type(value) == 'table' then
        for i = 1, #value do
          table.insert(combo, value[i])
        end
      end
      -- for i = 1,#t2 do
      --   t3[#t1+i] = t2[i]
      -- end

      table.insert(combos, combo)
    end
  end

  return combos
end

local file = assert(io.open(arg[1]))
local lines = {}
for x in file:lines() do lines[#lines+1] = x end
file:close()

local combinations = combineWithoutRepetitions(lines, 3)

print(#combinations)

for index, value in ipairs(combinations) do
  local sum = value[1] + value[2] + value[3]
  if sum == 2020 then
    print(value[1] , value[2] , value[3])
    print('Found', sum, value[1] * value[2] * value[3])
  end
end
