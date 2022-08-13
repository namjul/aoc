local inspect = require('inspect')
local utils = require('utils')


-- 0: 4 1 5
-- 1: 2 3 | 3 5
-- 2: 4 4 | 5 5
-- 3: 4 5 | 5 4
-- 4: "a"
-- 5: "b"
--
-- 4 1 5
-- 4 1(2 3 | 3 2) 5
-- 4 1(2(4 4 | 5 5) 3(4 5 | 5 4) | 3(4 5 | 5 4) 2(4 4 | 5 5)) 5
-- a (((a a) | (b b)) ((a b) | (b a)) | ((a b) | (b a)) ((a a) | (b b))) b
--
--               4        1       5
--                   /       \
--           /    23          35   \
--              /\/\         /\ \
--         4 44 55 45 54  45 54  5  5
--         a aa|bb ab|ba  ab|ba  a  b
--
-- a(aaab)b
-- a(aaba)b
-- a(bbab)b
-- a(bbba)b
-- a(abaa)b
-- a(abbb)b
-- a(baaa)b
-- a(babb)b
--
--           {1,4,1} -> indices -> 1-1,2-4,6-6 -> a((aa)(ab))b
--           {4,{{{4,4},{5,5}},{{4,5},{5,4}}},{{{4,5},{5,4}},{{4,4},{5,5}}},5},
--           {
--              4 = "a",
--              1 = {
--                { 2, 3 },
--                { 3, 2 }
--              },
--              2 = {
--                {4, 4},
--                {5, 5},
--              },
--              3 = {
--                {4, 5},
--                {5, 4},
--              },
--              5 = "b"
--           }
--
--           {
--              a,
--              { a, b },
--
--           }
--
--
-- 0: 4 1 5
-- 1: 2 3 | 3 2
-- 2: 4 4 | 5 5
-- 3: 4 5 | 5 4
-- 4: "a"
-- 5: "b"
--
--
--               4        1       5
--                   /       \
--           /    23          32   \
--              /\/\         /\ \
--         4 44 55 45 54  45 54  5  5
--         a aa|bb ab|ba  ab|ba  a  b
--
-- solved with help from https://github.com/jwise/aoc/blob/master/2020/19.lua
--

-- local rules = {
--   [0] = {{4,1,5}},
--   [1] = {{2,3},{3,2}},
--   [2] = {{4,4},{5,5}},
--   [3] = {{4,5},{5,4}},
--   [4] = 'a',
--   [5] = 'b',
-- }


local rules = {}
local input = nil

for line in utils.day(19) do
  if line == '' then
    input = {}
  elseif input == nil then
    local num, txt = line:match('(%d+): (.+)')
    if txt:match('\"[ab]\"') then
      rules[tonumber(num)] = txt:match('\"([ab])\"')
    else
      local result
      if num == '8' then
        result = {{42}, {42, 8}}
      elseif num == '11' then
        result = {{42, 31}, {42,11,31}}
      end

      rules[tonumber(num)] = result or utils.map({utils.split(txt, '|')}, function(value)
        local result = {}
        for y in value:gmatch('%d+') do
          table.insert(result, tonumber(y))
        end
        return result
      end)
    end
  else
    table.insert(input, line)
  end
end
print(inspect(rules), inspect(input))

local function match(line, n)

  -- print(n, inspect(rules[n]), line)
  if line:sub(1,1) == rules[n] then
    -- print('--')
    -- print(n, rules[n], line)
    -- print('--')
    return line:sub(2)
  else
    for _, opt in ipairs(rules[n]) do -- at least one option needs to pass
      local tmp = line
      local ok = true
      for _, n2 in ipairs(opt) do

          print(n, inspect(rules[n]), n2, inspect(rules[n2]), tmp)
          print('--')

        tmp = match(tmp, n2)
        -- print('==')
        if not tmp then
          ok = false
          print('BREAK')
          break
        end
      end

      if ok and (n ~= 0 or tmp == '') then -- when we reached the end (n=0) tmp should be empty
        print('RETURN', inspect(opt), tmp)
        return tmp
      end

    end
  end

  -- print('nil', n, line)

  return nil
end

-- TODO solve with help of https://github.com/jwise/aoc/blob/master/2020/19.lua
print('result: ', match('babbbbaabbbbbabbbbbbaabaaabaaa', 0))

-- local count = 0
-- for _, inputValue in ipairs(input) do
--   print(inputValue,  match(inputValue, 0))
--   if match(inputValue, 0) then
--     count = count + 1
--   end
-- end

-- print(count)

