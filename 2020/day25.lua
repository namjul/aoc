

local publicKeys = {3418282, 8719412}
-- local publicKeys = {17807724, 5764801}

local function transform(loopSize, subjectNumber)
  subjectNumber = subjectNumber or 7

  local value = 1

  for _=1, loopSize do
    value = value * subjectNumber
    value = value % 20201227
  end

  return value
end

local function bruteForce(key)
  local loopSize = 0
  local value = 1

  while true do

    value = value * 7
    value = value % 20201227

    loopSize = loopSize + 1
    if value == key then
      return loopSize
    end

  end

end

local loopSizeCard = bruteForce(publicKeys[1])
local loopSizeDoor = bruteForce(publicKeys[2])

-- print(loopSizeCard, loopSizeDoor)

local encryptionKeyCard = transform(loopSizeCard, publicKeys[2])
local encryptionKeyDoor = transform(loopSizeDoor, publicKeys[1])

print(encryptionKeyCard == encryptionKeyDoor, encryptionKeyCard, encryptionKeyDoor)
