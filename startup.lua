-- Setup
currentPos = {}
io.write("Enter turtle position X Y Z ")
for entry in io.read():gmatch("%S+") do table.insert(currentPos, entry) end

io.write("Enter turtle heading (north, south etc.) ")
local currentHeading = io.read()

local posOne = {}
io.write("Enter a corner X Y Z ")
for entry in io.read():gmatch("%S+") do table.insert(posOne, entry) end

local posTwo = {}
io.write("Enter opposite corner X Y Z ")
for entry in io.read():gmatch("%S+") do table.insert(posTwo, entry) end

-- Helper functions:
local headingValues = {
    ["north"] = 0, -- -Z
    ["east"] = 1, -- +X
    ["south"] = 2, -- +Z
    ["west"] = 3, -- -X
}

--[[
    from => to == diff
    
    north => north == 0
    north => east == 1
    north => west == 3
    east => west == 2
    west => north == -3
    west => east == -2
]]

local function rotateTo(heading)
    if heading == currentHeading then return end

    local headingDiff = headingValues[heading] - headingValues[currentHeading]
    
    -- Shortest rotation handling
    local absHeadingDiff = math.abs(headingDiff)
    if absHeadingDiff == 3 then
        headingDiff = headingDiff / absHeadingDiff * -1
        absHeadingDiff = 1
    end

    local turn
    if headingDiff > 0 then turn = turtle.turnRight else turn = turtle.turnLeft end
    for i=1, absHeadingDiff do
        turn()
    end

    currentHeading = heading
end

local function getMoveVector(currPos, targetPos)
    return { targetPos[1] - currPos[1], targetPos[2] - currPos[2], targetPos[3] - currPos[3] }
end

local function moveTo(pos)    
    local moveVec = getMoveVector(currentPos, pos)

    -- Go over the x-axis
    if moveVec[1] ~= 0 then
        if moveVec[1] >= 0 then
            rotateTo("east")
        else
            rotateTo("west")
        end
        for i = 1, math.abs(moveVec[1]) do
            turtle.dig()
            turtle.forward()
        end
    end

    -- Go over the z-axis
    if moveVec[3] ~= 0 then
        if moveVec[3] <= 0 then
            rotateTo("north")
        else
            rotateTo("south")
        end
        for i = 1, math.abs(moveVec[3]) do
            turtle.dig()
            turtle.forward()
        end
    end

    -- Go over the y-axis
    if moveVec[2] ~= 0 then
        local upDownFunc
        local upDownDigFunc
        if moveVec[2] < 0 then
            upDownFunc = turtle.down
            upDownDigFunc = turtle.digDown
        else
            upDownFunc = turtle.up
            upDownDigFunc = turtle.digUp
        end
        for i = 1, math.abs(moveVec[2]) do
            upDownDigFunc()
            upDownFunc()
        end
    end

    currentPos = pos
end

-- Move to initial position
turtle.refuel()
moveTo(posOne)
    
-- Mine inside defined area
local diffPos = { posTwo[1] - posOne[1], posTwo[2] - posOne[2], posTwo[3] - posOne[3] }
for y = posOne[2], posTwo[2], diffPos[2]/math.abs(diffPos[2]) do
    for z = posOne[3], posTwo[3], diffPos[3]/math.abs(diffPos[3]) do
        for x = posOne[1], posTwo[1], diffPos[1]/math.abs(diffPos[1]) do
            moveTo( {x, y, z} )
        end
    end
end
