local utils = require('utils')
local inspect = require('inspect')



local decks = {}
local player

for line in utils.day(22) do
  if line:match('Player (%d)') then
    player = tonumber(line:match('Player (%d)'))
  elseif line ~= '' then
    local deck = decks[player] or {}
     table.insert(deck, tonumber(line))
     decks[player] = deck
  end
end

-- print(inspect(decks))

local function play(decks)
  local first1, rest1 = decks[1][1], {table.unpack(decks[1], 2)}
  local first2, rest2 = decks[2][1], {table.unpack(decks[2], 2)}

  if not first1 then
    return decks[2]
  elseif not first2 then
    return decks[1]
  end

  if first1 > first2 then
    table.insert(rest1, first1)
    table.insert(rest1, first2)
  else
    table.insert(rest2, first2)
    table.insert(rest2, first1)
  end

  decks[1] = rest1
  decks[2] = rest2

  return play(decks)
end

local winner = play(decks)
local result = utils.map(winner, function(card, index, list) 
  return card * (#list - index + 1)
end)

print(inspect(utils.sum(result)))

