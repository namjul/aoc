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

local function play1(decks)
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

  return play1(decks)
end


local games = {}

local function play2(_decks, gameId, round)

  round = round or 1
  gameId = gameId or 1

  if not games[gameId] then
    -- new game
    games[gameId] = {{},{}}
  end

  local game = games[gameId]
  if game[1][table.concat(_decks[1])] or game[2][table.concat(_decks[2])] then
    return 1, _decks -- 1 wins
  end

  -- cache current deck
  game[1][table.concat(_decks[1])] = true
  game[2][table.concat(_decks[2])] = true

  local first1, rest1 = _decks[1][1], {table.unpack(_decks[1], 2)}
  local first2, rest2 = _decks[2][1], {table.unpack(_decks[2], 2)}

  if not first1 then
    return 2, _decks -- 2 wins
  elseif not first2 then
    return 1, _decks -- 1 wins
  end

  -- print('playing game ', gameId, 'round ', round)

  local winner = nil

  if #rest1 >= first1 and #rest2 >= first2 then
    -- print('play sub-game: ', #games + 1)
    winner = play2({{table.unpack(rest1, 1, first1)}, {table.unpack(rest2, 1, first2)}}, #games + 1, 1)
  end

  if not winner then
    if first1 > first2 then
      winner = 1
    else
      winner = 2
    end
  end

  if winner == 1 then
    table.insert(rest1, first1)
    table.insert(rest1, first2)
  else
    table.insert(rest2, first2)
    table.insert(rest2, first1)
  end

  _decks[1] = rest1
  _decks[2] = rest2

  local result1, result2 = play2(_decks, gameId, round + 1)
  return result1, result2
end

local winner, result = play2(decks)
print(winner, inspect(result))

local result = utils.map(decks[winner], function(card, index, list)
  return card * (#list - index + 1)
end)

print(inspect(utils.sum(result)))
