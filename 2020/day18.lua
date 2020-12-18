local utils = require('utils')
local inspect = require('inspect')

-- run `lua ./day18.lua`

-- little parser with the help from http://lisperator.net/pltut/parser/
--
--  1 + 2 * 3 + 4 * 5 + 6
--    3   * 3 + 4 * 5 + 6
--        9   + 4 * 5 + 6
--           13   * 5 + 6
--               65   + 6
--                   71
--
--  1 + (2 * 3) + (4 * (5 + 6))
--  1 +    6    + (4 * (5 + 6))
--       7      + (4 * (5 + 6))
--       7      + (4 *   11   )
--       7      +     44
--              51
--

local file = assert(io.open('day18-input.txt'))
local code = file:read("*all")
file:close()

--
-- InputStream
-- "stream object" to read characters from string.
-- entails 4 methods:
-- peek() — returns the next value but without removing it from the stream.
-- next() — returns the next value and also discards it from the stream.
-- eof() — returns true if and only if there are no more values in the stream.
-- croak(msg) — does throw new Error(msg).

local InputStream = {}
function InputStream.new(self, input)
  local t = setmetatable({}, { __index = self })
  t.input = input
  t.pos = 1
  return t
end
function InputStream.next(self)
  local ch = self.input:sub(self.pos, self.pos)
  self.pos = self.pos + 1
  return ch
end
function InputStream.peek(self)
  return self.input:sub(self.pos, self.pos)
end
function InputStream.eof(self)
  return self:peek() == ''
end
function InputStream.croak(_, msg)
  error(msg or '')
end

--
-- TokenStream
-- The tokenizer (also called "lexer") operates on a character input stream (InputStream) and
-- returns a stream object with the same interface.
-- But the values returned will be tokens:
-- { type: "punc", value: "(" } – punctuation: parens, comma, semicolon etc.
-- { type: "num", value: 5 } – numbers
-- { type: "op", value: "+" } – operators
--

local TokenStream = {}
function TokenStream.new(self, input)
  local t = setmetatable({}, { __index = self })
  t.input = input

  -- Helper
  t.isWhitespace = function(ch)
    return ch == ' '
  end
  t.isPunc = function(ch)
    return ch:match('[%(%)\n]') and true or false
  end
  t.isDigit = function(ch)
    return ch:match('%d') and true or false
  end
  t.isOpChar = function(ch)
    return ch:match('[%+%*]') and true or false
  end

  t.readWhile = function(predicate)
    local str = ''
    while not t.input:eof() and predicate(t.input:peek()) do
      str = str..t.input:next()
    end
    return str
  end

  t.readNumber = function()
    local number = t.readWhile(t.isDigit)
   return { type = 'num', value = tonumber(number) }
  end

  t.readNext = function()
    t.readWhile(t.isWhitespace)
    if t.input:eof() then
      return nil
    end
    local ch = t.input:peek()
    if t.isPunc(ch) then
      return {
        type = 'punc',
        value = t.input:next()
      }
    end
    if t.isDigit(ch) then
      return t.readNumber()
    end
    if t.isOpChar(ch) then
      local result = {
        type = 'op',
        value = t.readWhile(t.isOpChar)
      }
      return result
    end

    return t.input:croak("Can't handle character: "..ch);
  end

  return t
end
function TokenStream.peek(self)
  self.current = self.current or self:readNext()
  return self.current
end
function TokenStream.next(self)
  local tok = self.current
  self.current = nil
  return tok or self:readNext()
end
function TokenStream.eof(self)
  return self:peek() == nil
end
function TokenStream.croak(self, msg)
  return self.input:croak(msg)
end


--
-- Parser
-- The parser creates AST nodes:
-- { type: 'num', value: NUMBER }
-- { type: 'binary', operator: OPERATOR, left: AST }
--

local function parse(input)

  local parseAtom, parseExpression
  local PRECEDENCE = {
    ['*'] = 10,
    ['+'] = 20,
  }

  local function isPunc(ch)
    local tok = input:peek()
    return tok and tok.type == 'punc' and (not ch or tok.value == ch) and tok
  end

  local function isOp(op)
    local tok = input:peek()
    return tok and tok.type == 'op' and (not op or tok.value == op) and tok
  end

  local function skipPunc(ch)
    if isPunc(ch) then
      input:next()
    else
      input:croak('Expecting punctuation: \"'..ch..'\"')
    end
  end

  local function maybeBinary(left, myPrec)
    local tok = isOp()
    if tok then
      local hisPrec = PRECEDENCE[tok.value];
      if hisPrec > myPrec then
        input:next()
        local right = maybeBinary(parseAtom(), hisPrec)
        return maybeBinary({
          type = 'binary',
          operator = tok.value,
          left = left,
          right = right
        }, myPrec)
      end
    end
    return left
  end

  function parseAtom()
    if isPunc('(') then
      input:next()
      local exp = parseExpression()
      skipPunc(')')
      return exp
    end
    local tok = input:next()
    return tok
  end

  function parseExpression()
    return maybeBinary(parseAtom(), 0)
  end

  local prog = {}
  while not input:eof() do
    table.insert(prog, parseExpression())
    if not input:eof() then
      skipPunc('\n')
    end
  end
  return { type = 'prog', prog = prog }
end

local function evaluate(exp)
  local function applyOp(op, left, right)
    local function num(x)
      if type(x) ~= 'number' then
        error('Expected number but go '..x)
      end
      return x
    end

    if op == '+' then
      return num(left) + num(right)
    elseif op == '*' then
      return num(left) * num(right)
    end
    error('Can\'t apply operator '..op);
  end

  if exp.type == 'num' then
    return exp.value
  end

  if exp.type == 'prog' then
    local value = 0
    utils.forEach(exp.prog, function(exp)
      value = value + evaluate(exp)
    end)
    return value
  end
  if exp.type == 'binary' then
    return applyOp(exp.operator,
      evaluate(exp.left),
      evaluate(exp.right));
  end
end

local ast = parse(TokenStream:new(InputStream:new(code)))
print(evaluate(ast))
