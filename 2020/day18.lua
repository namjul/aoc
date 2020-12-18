local utils = require('utils')
local inspect = require('inspect')

-- run `lua ./day18.lua`

-- Tokens:
-- { type: "punc", value: "(" } punctuation: parens, comma, semicolon etc.
-- { type: "num", value: 5 } numbers
-- { type: "op", value: "+" } operators

-- AST:
-- { type: 'num', value: 5 }
-- { type:  }

local file = assert(io.open('day18-input.txt'))
local code = file:read("*all")
file:close()

--
-- Helper
--

local function isWhitespace(ch)
  return ch:match('%s') and true or false
end
local function isPunc(ch)
  return ch:match('[%(%)]') and true or false
end
local function isDigit(ch)
  return ch:match('%d') and true or false
end
local function isOpChar(ch)
  return ch:match('[%+%*]') and true or false
end

--
-- InputStream
--

local InputStream = {}
function InputStream.new(self, input)
  local t = setmetatable({}, { __index = self })
  t.input = input
  t.pos = 1
  t.line = 1
  t.col = 1
  return t
end
function InputStream.next(self)
  local ch = self.input:sub(self.pos, self.pos)
  self.pos = self.pos + 1
  if ch == '\n' then
    self.line = self.line + 1
    self.col = 1
  else
    self.col = self.col + 1
  end
  return ch
end
function InputStream.peek(self)
  return self.input:sub(self.pos, self.pos)
end
function InputStream.eof(self)
  return self:peek() == '';
end
function InputStream.croak(self, msg)
  error((msg or '')..' ('..self.line..':'..self.col..')')
end

--
-- TokenStream
--

local TokenStream = {}
function TokenStream.new(self, input)
  local t = setmetatable({}, { __index = self })
  t.input = input
  return t
end
function TokenStream.readWhile(self, predicate)
  local str = ''
  while not self.input:eof() and predicate(self.input:peek()) do
    str = str..self.input:next()
  end
  return str
end
function TokenStream.readNumber(self)
  local number = self:readWhile(isDigit)
 return { type = 'num', value = tonumber(number) }
end
function TokenStream.readNext(self)
  self:readWhile(isWhitespace)
  if self.input:eof() then
    return nil
  end
  local ch = self.input:peek()
  if isPunc(ch) then
    return {
      type = 'punc',
      value = self.input:next()
    }
  end
  if isDigit(ch) then
    return self:readNumber()
  end
  if isOpChar(ch) then
    return {
      type = 'op',
      value = self:readWhile(isOpChar)
    }
  end

  return self.input:croak("Can't handle character: "..ch);
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


--
-- Parser
--

local function parse(input)
  local prog = {}
  while not input:eof() do
    table.insert(prog, input:next())
  end
  return { type = 'prog', prog = prog }
end

local function evaluate(ast)
  print('AST: ', inspect(ast))
end

local ast = parse(TokenStream:new(InputStream:new(code)))
evaluate(ast)
