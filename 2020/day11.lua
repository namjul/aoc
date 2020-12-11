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
  seats[y] = seats[y] or {}

  local x = 1
  for character in string.gmatch(row, '.') do
    seats[x..':'..y] = character
    seats[y][x] = character
    x = x + 1
  end
end

local function printSeats(seats)
  print('--')
  for y,row in ipairs(rows) do
    local x = 1
    for _ in string.gmatch(row, '.') do
      io.write(seats[y][x])
      x = x + 1
    end
    io.write('\n')
  end
  print('--')
end

-- print(printSeats(seats))
-- print('--')


local function coordinateKey(coordinate)
  return math.floor(coordinate[1])..':'..math.floor(coordinate[2])
end

local function run(seats, lookupFn)
  local newSeats = {}
  local changes = false

  for y,row in ipairs(seats) do
   newSeats[y] = newSeats[y] or {}
    for x,seat in ipairs(row) do
      newSeats[x] = newSeats[x] or {}
      local neighborCount = lookupFn(seats, {x, y})
      if seat == 'L' and neighborCount == 0 then
        changes = true
        newSeats[y][x] = '#'
      elseif seat == '#' and neighborCount >= 5 then
        changes = true
        newSeats[y][x] = 'L'
      else
        newSeats[y][x] = seat
      end
    end
  end
  return newSeats, changes
end

local function lookupSurround(seats, origin)
  local x, y = table.unpack(origin)
  local adjacentSeats = {
    {x-1,y-1}, {x,y-1}, {x+1,y-1},
    {x-1,y},            {x+1,y},
    {x-1,y+1}, {x,y+1}, {x+1,y+1}
  }
  return #utils.filter(adjacentSeats, function (adjacentSeat)
    return (seats[adjacentSeat[2]] or {})[adjacentSeat[1]] == '#'
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
    local x, y = table.unpack(origin)
    while true do
      x = math.floor(x + dx)
      y = math.floor(y + dy)
      local seat = (seats[y] or {})[x]
      -- print('origin: '..inspect(origin), 'x: '..x, 'y: '..y, 'seat: '..(seat or 'nil'))
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
    -- print('directionSeat: ', inspect(directionSeats))
  end
    -- print('-')
  return #utils.filter(directionSeats, function (v) return v == '#' end)
end

local finished = false
local currentSeats = utils.clone(seats)
while not finished do
  local newSeats, changes = run(currentSeats, lookupDiagonal)
  printSeats(newSeats)
  if changes then
    currentSeats = newSeats
  else
    finished = true
  end
end

local sum = utils.sum(utils.map(currentSeats, function (row)
  return #utils.filter(row, function (v) return v == '#' end)
end))

print(sum)
