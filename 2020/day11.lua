local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day11.lua`

local rows = {}
for line in utils.day(11) do
  table.insert(rows, line)
end

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

local function coordinateKey(coordinate)
  return math.floor(coordinate[1])..':'..math.floor(coordinate[2])
end

local function lookupSurround(seats, origin)
  local x, y = utils.split(origin, ':')
  local adjacentSeats = {
    {x-1,y-1}, {x,y-1}, {x+1,y-1},
    {x-1,y},            {x+1,y},
    {x-1,y+1}, {x,y+1}, {x+1,y+1}
  }
  return #utils.filter(adjacentSeats, function (adjacentSeat)
    return seats[coordinateKey(adjacentSeat)] == '#'
  end)

end

local function lookupDiagonal(seats, origin)
  local directions = {
    {-1,-1}, {0,-1}, {1,-1},
    {-1,0},          {1,0},
    {-1,1},  {0,1},  {1,1}
  }

  local directionSeats = {}
  for _, direction in ipairs(directions) do
    local dx = direction[1]
    local dy = direction[2]
    local x, y = utils.split(origin, ':')
    while true do
      x = x + dx
      y = y + dy
      local seat = seats[coordinateKey({x,y})]
      if seat == nil then
        table.insert(directionSeats, '.')
        break
      end
      if seat == 'L' then
        table.insert(directionSeats, 'L')
        break
      end
      if seat == '#' then
        table.insert(directionSeats, '#')
        break
      end
    end
  end
  return #utils.filter(directionSeats, function (v) return v == '#' end)
end

local function run(seats, lookupFn, neighborCountMax)
  local newSeats = {}
  local changes = false

  for coordinate, seat in pairs(seats) do
    local neighborCount = lookupFn(seats, coordinate)
    if seat == 'L' and neighborCount == 0 then
      changes = true
      newSeats[coordinate] = '#'
    elseif seat == '#' and neighborCount >= neighborCountMax then
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
  local newSeats, changes = run(currentSeats, lookupDiagonal, 5)
  if changes then
    currentSeats = newSeats
  else
    finished = true
  end
end

print(#utils.filter(currentSeats, function (v) return v == '#' end))
