local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day21.lua`


local ingredients = {}
local intersections = {}

for line in utils.day(21) do
  local capture1, capture2 = line:match('([%a%s]+)%s%(contains%s(.+)%)')
  local lineIngredients = {utils.split(capture1, ' ')}
  local lineAllergens = {utils.split(capture2, ', ')}

  -- print('lineIngredients', inspect(lineIngredients))
  -- print('lineAllergens', inspect(lineAllergens))

  for _,ingredient in ipairs(lineIngredients) do
    ingredients[ingredient] = (ingredients[ingredient] or 0) + 1
  end
  for _, allergen in ipairs(lineAllergens) do
    possibleAllergenIngredients = intersections[allergen] or lineIngredients
    intersections[allergen] = utils.intersection(possibleAllergenIngredients, lineIngredients)
  end
end

-- print('ingredients', inspect(utils.keys(ingredients)))
-- print('intersections', inspect(intersections))

local intersectionsList = utils.map(intersections, function(value, key) return {key, value}  end)
table.sort(intersectionsList, function(a,b)
  return #a[2] < #b[2]
end)

-- part 1
local set = {}
for _, value in ipairs(intersectionsList) do
  for _,ingredient in ipairs(value[2]) do
    set[ingredient] = true
  end
end

local count = 0
for _,val in ipairs(utils.difference(utils.keys(ingredients), utils.keys(set))) do
  count = count + ingredients[val]
end
print(count)


-- part 2

local function recursive(list)
  if #list == 0 then
    return list
  end
  local first = list[1]
  local rest = utils.map({table.unpack(list, 2)}, function(value)
    return { value[1], utils.difference(value[2], first[2]) }
  end)

  table.sort(rest, function(a,b)
    return #a[2] < #b[2]
  end)

  local result = {first}

  for _,value in ipairs(recursive(rest)) do
    table.insert(result, value)
  end

  return result
end

local result = recursive(intersectionsList)
table.sort(result, function(a,b) return a[1] < b[1] end)
print(inspect(table.concat(utils.map(result, function(value) return value[2][1] end), ',')))
