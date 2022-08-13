local inspect = require('inspect')

local function log(x) 
    if type(x) == 'table' then
        for k, v in pairs(x) do
            print('key: '..k.. ' value: '.. tostring(v)) 
        end
        print('')
    else
        print(x)
    end
end

local currentCups = {3, 8, 9, 1, 2, 5, 4, 6, 7}
local currentCupIndex = 1

for i=1,10 do

    local beforeCurrentCups = {table.unpack(currentCups,1,currentCupIndex - 1)}

    local currentCup = currentCups[currentCupIndex]
    -- print('currentCup'..currentCup)
    --log('currentCupIndex'..currentCupIndex) 
    local pickUp = {
        currentCups[(currentCupIndex + 1) % #currentCups],
        currentCups[(currentCupIndex + 2) % #currentCups],
        currentCups[(currentCupIndex + 3) % #currentCups],
    }

    
    local restCurrentCups = {table.unpack(currentCups, currentCupIndex + 4)}
 
  print('-- move '..i..' --', inspect(restCurrentCups))
  print('cups: ', table.concat(beforeCurrentCups)..'('..currentCup..')'..table.concat(pickUp)..table.concat(restCurrentCups), table.concat(currentCups))
    -- print('pickUp', inspect(pickUp), currentCups[currentCupIndex + 3])
    -- log(pickUp)  
    
    local circle = {} 
    
    for _, v in ipairs(beforeCurrentCups) do
        table.insert(circle, v) 
    end
    
    table.insert(circle, currentCup) 
    
    for _, v in ipairs(restCurrentCups) do
        table.insert(circle, v) 
    end
    --log(circle) 
    
    local destinationCup = currentCup - 1
    
    if pickUp[1] == destinationCup then
        destinationCup = destinationCup - 1
    end
        
    if pickUp[2] == destinationCup then
        destinationCup = destinationCup - 1
    end 
    
    if pickUp[3] == destinationCup then
        destinationCup = destinationCup - 1
    end
    
    if destinationCup < math.min(table.unpack(circle)) then
        destinationCup = math.max(table.unpack(circle))
    end
    
    print('destination: '..destinationCup) 
    
    local currentIndex = currentCupIndex
    local destinationCupIndex
    
    while true do
        if destinationCup == circle[currentIndex] then
            destinationCupIndex = currentIndex
            break
        end
        local index = (currentIndex + 1) % #circle
        currentIndex = (index == 0 and #circle or index)
    end
   
    -- log('destinationCupIndex'..destinationCupIndex)
   
    local newCurrentCups = {}
   
    for _, v in ipairs({table.unpack(circle, 1, destinationCupIndex)}) do
        table.insert(newCurrentCups, v)
    end

    print('#newCurrentCups', #newCurrentCups)
    currentCupIndex = #newCurrentCups

    for _, v in ipairs(pickUp) do
        table.insert(newCurrentCups, v)
    end
   
    for _, v in ipairs({table.unpack(circle, destinationCupIndex + 1)}) do
        table.insert(newCurrentCups, v)
    end
   
   
    currentCups = newCurrentCups
    -- currentCupIndex = (#beforeCurrentCups == 0 and 1 or #beforeCurrentCups) + 1
   
   
    --log('currentIndex'..currentIndex) 
   
   
    --log(beforeCurrentCups) 
    -- log(currentCups) 
    --print(currentCups[currentIndex])
    -- print('==') 
end
