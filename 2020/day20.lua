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

-- {
--   ["1171"] = { "1489", "2473" },
--   ["1427"] = { "2729", "1489", "2473", "2311" },
--   ["1489"] = { "2971", "1427", "1171" },
--   ["1951"] = { "2729", "2311" },
--   ["2311"] = { "1951", "1427", "3079" },
--   ["2473"] = { "1427", "1171", "3079" },
--   ["2729"] = { "1951", "2971", "1427" },
--   ["2971"] = { "2729", "1489" },
--   ["3079"] = { "2473", "2311" }
-- }
--
-- {{}{1489, 1171}}


local current
local tileRow
local tiles = {}

-- tile structure:
-- index
-- 1: top
-- 2: right
-- 3: bottom
-- 4: left

local directions = {
  'top',
  'right',
  'bottom',
  'left',
}

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

-- local commandMap = {
--   ['top'] = {
--     {
--       vFlip = true,
--       hFlop = false,
--       rotate = 0,
--     },
--     {
--       vFlip = false,
--       hFlop = true,
--       rotate = -1,
--     }
--   },
--   ['right'] = {
--     {
      
--     }
--   }
-- }

local function isMatch(tile1, tile2)
  local result = {}
  for tile1Index, edge1 in ipairs(tile1) do
    for tile2Index, edge2 in ipairs(tile2) do
      local directionAbs, directionRel = tile1Index, tile2Index
      local matchesSame = edge1 == edge2
      local matchesReverse = edge1 == edge2:reverse()
      if matchesSame or matchesReverse then
        table.insert(
          result,
          { 
            id = tile2.id,
            directionAbs = directions[directionAbs],
            directionRel = directions[directionRel],
            type = matchesSame and 'same' or 'reverse',
          }
        )
      end
    end
  end
  return result
end

-- local matchCount = {}
-- local matchMap = {}
-- local combinations = utils.permutateWithRepetition(
--   utils.map(
--     tiles,
--     function(edges, key) return {id = key, edges = edges} end),
--   2
-- )
-- utils.forEach(combinations, function(combi) print(inspect({combi[1].id, combi[2].id})) end)

-- for _, value in ipairs(combinations) do
--   local tile1, tile2 = table.unpack(value)
--   if tile1.id ~= tile2.id then
--     local matches = isMatch(tile1, tile2)
--     if #matches > 0 then
--       tile1Matches = matchMap[tile1.id] or {}
--       table.insert(tile1Matches, matches[1])
--       matchMap[tile1.id] = tile1Matches
--       matchCount[tile1.id] = (matchCount[tile1.id] or 0) + 1
--     end
--   end
-- end

-- print(inspect(matchMap))

-- part 1
-- local count = 1
-- for id, value in pairs(matchCount) do
--   if value == 2 then
--     count = count * id
--   end
-- end
-- print(count)

-- part 2

-- local function recursive(id, result, coordinate)
--   coordinate = coordinate or {0, 0}

--   if coordinate[1] > 10 or coordinate[1] < -10 then
--     return nil
--   end
--   -- print(inspect(coordinate), coordinate[1])
--   local matches = matchMap[id]
--   -- local edges = tiles[id]

--   local strCoordinate = coordinate[1]..':'..coordinate[2]

--   -- if field already covered
--   if result[strCoordinate] then
--     return nil
--   end

--   result[strCoordinate] = {id, utils.map(matchMap[id], function(match) return match.id end)}

--   for _, match in ipairs(matches) do
--     local x, y = 0, 0

--     if match.directionAbs == 'top' then
--       y = 1
--     elseif match.directionAbs == 'right' then
--       x = 1
--     elseif match.directionAbs == 'bottom' then
--       y = -1
--     elseif match.directionAbs == 'left' then
--       x = -1
--     end

--     recursive(match.id, result, {coordinate[1] + x, coordinate[2] + y})
--   end
-- end


--
--  {
--    ['1233:1:0'] = {
--      edges: { "#.#.#####.", ".#....#...", "...###.#..", "...#.##..#" }
--      field: '#.#.#####.\n'
--      rotate = -1,
--      vFlip = true,
--      hFlip = false
--    }
--  }

local cache = {}
local function recursive(id, result, attributes, lastPosition)

  if cache[id] then
    return nil
  else
    cache[id] = true
  end

  lastPosition = attributes and lastPosition or {0, 0}
  local edges = tiles[id]

  if attributes then

    -- TODO adjust directionAbs
    -- TODO calculate myPosition
  end


  for _id, _edges in pairs(tiles) do
    if id ~= _id then
      local matches = isMatch(edges, _edges)
      if #matches > 0 then
        print('id: ', _id, 'attributes: ', inspect(matches[1]), myPosition)
        -- TODO run recursive on each match
        -- recursive(_id, result, matches[1])
      end

    end
  end


end
local result = {}
recursive('1171', result)
print('result: ', inspect(result))
