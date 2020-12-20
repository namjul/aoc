local inspect = require('inspect')
local utils = require('utils')

-- run `lua ./day20.lua`

-- Tile 2311:
-- ..##.#..#.
-- ##..#.....
-- #...##..#.
-- ####.#...#
-- ##.##.###.
-- ##...#.###
-- .#.#.#..##
-- ..#....#..
-- ###...#.#.
-- ..###..###
-- 
-- Tile 1951:
-- #.##...##.
-- #.####...#
-- .....#..##
-- #...######
-- .##.#....#
-- .###.#####
-- ###.##.##.
-- .###....#.
-- ..#.#..#.#
-- #...##.#..
-- 
-- Tile 1171:
-- ####...##.
-- #..##.#..#
-- ##.#..#.#.
-- .###.####.
-- ..###.####
-- .##....##.
-- .#...####.
-- #.##.####.
-- ####..#...
-- .....##...
-- 
-- Tile 1427:
-- ###.##.#..
-- .#..#.##..
-- .#.##.#..#
-- #.#.#.##.#
-- ....#...##
-- ...##..##.
-- ...#.#####
-- .#.####.#.
-- ..#..###.#
-- ..##.#..#.
-- 
-- Tile 1489:
-- ##.#.#....
-- ..##...#..
-- .##..##...
-- ..#...#...
-- #####...#.
-- #..#.#.#.#
-- ...#.#.#..
-- ##.#...##.
-- ..##.##.##
-- ###.##.#..
-- 
-- Tile 2473:
-- #....####.
-- #..#.##...
-- #.##..#...
-- ######.#.#
-- .#...#.#.#
-- .#########
-- .###.#..#.
-- ########.#
-- ##...##.#.
-- ..###.#.#.
-- 
-- Tile 2971:
-- ..#.#....#
-- #...###...
-- #.#.###...
-- ##.##..#..
-- .#####..##
-- .#..####.#
-- #..#.#..#.
-- ..####.###
-- ..#.#.###.
-- ...#.#.#.#
-- 
-- Tile 2729:
-- ...#.#.#.#
-- ####.#....
-- ..#.#.....
-- ....#..#.#
-- .##..##.#.
-- .#.####...
-- ####.#.#..
-- ##.####...
-- ##..#.##..
-- #.##...##.
-- 
-- Tile 3079:
-- #.#.#####.
-- .#..######
-- ..#.......
-- ######....
-- ####.#..#.
-- .#...#.##.
-- #.#####.##
-- ..#.###...
-- ..#.......
-- ..#.###...
--
--
-- 1951       2311       3079
-- #...##.#.. ..###..### #.#.#####.
-- ..#.#..#.# ###...#.#. .#..######
-- .###....#. ..#....#.. ..#.......
-- ###.##.##. .#.#.#..## ######....
-- .###.##### ##...#.### ####.#..#.
-- .##.#....# ##.##.###. .#...#.##.
-- #...###### ####.#...# #.#####.##
-- .....#..## #...##..#. ..#.###...
-- #.####...# ##..#..... ..#.......
-- #.##...##. ..##.#..#. ..#.###...
--
-- 2729       1427       2473
-- #.##...##. ..##.#..#. ..#.###...
-- ##..#.##.. ..#..###.# ##.##....#
-- ##.####... .#.####.#. ..#.###..#
-- ####.#.#.. ...#.##### ###.#..###
-- .#.####... ...##..##. .######.##
-- .##..##.#. ....#...## #.#.#.#...
-- ....#..#.# #.#.#.##.# #.###.###.
-- ..#.#..... .#.##.#..# #.###.##..
-- ####.#.... .#..#.##.. .######...
-- ...#.#.#.# ###.##.#.. .##...####
--
-- 2971       1489       1171
-- ...#.#.#.# ###.##.#.. .##...####
-- ..#.#.###. ..##.##.## #..#.##..#
-- ..####.### ##.#...##. .#.#..#.##
-- #..#.#..#. ...#.#.#.. .####.###.
-- .#..####.# #..#.#.#.# ####.###..
-- .#####..## #####...#. .##....##.
-- ##.##..#.. ..#...#... .####...#.
-- #.#.###... .##..##... .####.##.#
-- #...###... ..##...#.. ...#..####
-- ..#.#....# ##.#.#.... ...##.....
-- 
-- 
--
-- 1951    2311    3079
-- 2729    1427    2473
-- 2971    1489    1171
--

-- local x = {
--   [1951] = {2311,2729},
--   [2311] = {1951,1427,3079},
--   [3079] = {2311,2473},
--   [2729] = {1951,1472,2971}
--   [1427] = {}
--   [2473] = {}
--   [2971] = {}
--   [1489] = {}
--   [1171] = {}
-- }


local current
local tileRow
local tiles = {}

-- tile structure:
-- index
-- 1: top
-- 2: right
-- 3: bottom
-- 4: left

for line in utils.day(20) do
  local id = line:match('(%d+)')
  if id then
    current = id
    tileRow = 1
  else
    if line ~= '' then
      local tile = tiles[current] or {}

      if tileRow == 1 then
        tile[1] = line
      elseif tileRow == 10 then
        tile[3] = line:reverse()
      end
        local left, right = line:match('^([#.]).*([#.])$')
        tile[2] = (tile[2] or '')..right
        tile[4] = left..(tile[4] or '')
     
      tiles[current] = tile
      tileRow = tileRow + 1
    end
  end

end

print(inspect(tiles))

local function match(tile1, tile2)
  local result = {}
  for i, edge1 in ipairs(tile1) do
    for j, edge2 in ipairs(tile2) do
      if (edge1 == edge2) or (edge1 == edge2:reverse()) then
        table.insert(result, edge1)
      end
    end
  end
  return result
end

local matchCount = {}
local matchMap = {}
local combinations = utils.combineWithoutRepetitions(utils.map(tiles, function(edges, key) return {id = key, edges = edges} end), 2)
for _, value in ipairs(combinations) do
  local tile1, tile2 = table.unpack(value)
  local matches = match(tile1.edges, tile2.edges)
  if #matches > 0 then
    outerMatches = matchMap[tile1.id] or {}
    innerMatches = matchMap[tile2.id] or {}
    table.insert(outerMatches, tile2.id)
    table.insert(innerMatches, tile1.id)
    matchMap[tile1.id] = outerMatches
    matchMap[tile2.id] = innerMatches
    matchCount[tile1.id] = (matchCount[tile1.id] or 0) + 1
    matchCount[tile2.id] = (matchCount[tile2.id] or 0) + 1
  end
end

-- print(inspect(matchMap))

local count = 1
for id, value in pairs(matchCount) do
  if value == 2 then
    count = count * id
  end
end
print(count)
