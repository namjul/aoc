local inspect = require('inspect')

-- run `lua ./day3.lua ./day3-input.txt`

local file = assert(io.open(arg[1]))

local grid = {}
for x in file:lines() do
  local row = {}
  string.gsub(x, '.', function(character) table.insert(row, character) end)
  grid[#grid+1] = row
end
file:close()

local function slide(right, down)
  local trees = 0
  local position = right
  for index = down, #grid, down do
    local columns = grid[index + 1]
    if columns then
      if columns[position % #columns + 1] == '#' then
        trees = trees + 1
      end

      position = position + right
    end
  end

  return trees
end

print(slide(3, 1))
print(slide(1,1) * slide(3,1) * slide(5,1) * slide(7,1) * slide(1,2))
