local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day11.lua ./day11-input.txt`

local rows = {}
local file = assert(io.open(arg[1]))
for line in file:lines() do
  table.insert(rows, line)
end
file:close()

-- data structure:
-- a) {{'L', '.', 'L', ...}, {'L', 'L', ...}, ...}
-- b) {{0,0} = '.', {0,1} = '#', {0,2} = 'L', ...}
-- c) {'0:0' = '.', '0:1' = '#', '0.2' = 'L', ...}

local seats = {}
for y, row in ipairs(rows) do
  local x = 1
  for character in string.gmatch(row, '.') do
    seats[x..':'..y] = character
    x = x + 1
  end
end

-- print(inspect(seats))
-- print('--')

local function printSeats(seats)
  print('--')
  for y,row in ipairs(rows) do
    local x = 1
    for _ in string.gmatch(row, '.') do
      io.write(seats[x..':'..y])
      x = x + 1
    end
    io.write('\n')
  end
  print('--')
end

local function lookupSurround(seats, origin)
  local x, y = utils.split(origin, ':')
  local adjacentSeats = {
    {x-1,y-1}, {x,y-1}, {x+1,y-1},
    {x-1,y},            {x+1,y},
    {x-1,y+1}, {x,y+1}, {x+1,y+1}
  }
  return #utils.filter(adjacentSeats, function (adjacentSeat)
    local coordinate = math.floor((adjacentSeat[1]))..':'..math.floor((adjacentSeat[2]))
    return seats[coordinate] == '#'
  end)

end

local function run(seats, lookupFn)
  local newSeats = {}
  local changes = false

  for coordinate, seat in pairs(seats) do
    local neighborCount = lookupFn(seats, coordinate)
    if seat == 'L' and neighborCount == 0 then
      changes = true
      newSeats[coordinate] = '#'
    elseif seat == '#' and neighborCount >= 4 then
      changes = true
      newSeats[coordinate] = 'L'
    else
      newSeats[coordinate] = seat
    end
  end
  return newSeats, changes
end

local finished = false
local currentSeats = utils.clone(seats)
while not finished do
  local newSeats, changes = run(currentSeats, lookupSurround)
  if changes then
    currentSeats = newSeats
  else
    finished = true
  end
end

print(#utils.filter(currentSeats, function (v) return v == '#' end))
