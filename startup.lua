-- Setup
currentPos = {}
io.write("Enter turtle position X Y Z ")
for entry in io.read():gmatch("%S+") do table.insert(currentPos, entry) end

io.write("Enter turtle heading (north, south etc.) ")
local currentHeading = io.read()

local chestPos = {}
io.write("Enter chest coordinates X Y Z ")
for entry in io.read():gmatch("%S+") do table.insert(chestPos, entry) end

local posOne = {}
io.write("Enter a corner X Y Z ")
for entry in io.read():gmatch("%S+") do table.insert(posOne, entry) end

local posTwo = {}
io.write("Enter opposite corner X Y Z ")
for entry in io.read():gmatch("%S+") do table.insert(posTwo, entry) end

-- Loop
while true do
    --remove when fixing this but the states need to be set at these parts of the code
    digDir = "forward"
    digFloor()
    digDir = upDownDir
    digDown()
end

-- Helper functions:

local function distance(posOne, posTwo)
	return
end

local headingValues = {
    ["north"] = 0,
    ["east"] = 1,
    ["south"] = 2,
    ["west"] = 3,
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
end

local function moveTo(pos)
	local diffX = pos[1] - currentPos[1]
	local diffY = pos[2] - currentPos[2]
	local diffZ = pos[3] - currentPos[3]

    
end

local function getMoveVector(currPos, targetPos)
    return targetPos[0] - currPos[0], targetPos[1] - currPos[1], targetPos[2] - currPos[2]
end

local digDir = "forward" -- "up", "down", "forward" left and right are not used since the turtle should always face the block it want to dig.
local upDownDir = "down"

local function canHoldBlock()
    local blockName
    if (digDir == "forward") then
        blockName = turtle.inspect().name
    elseif (digDir == "up") then
        blockName = turtle.inspectUp().name
    elseif (digDir == "down") then
        blockName = turtle.inspectDown().name
    end

    for i = 1, 16 do
        if (block_name == turtle.getItemDetail(i).name) then
            return turtle.getItemSpace() > 0
        end
    end
    return false
end


-- Tasks: 
-- go to start location (minning allowed)
-- once at start location dig in and go floor by floor? (hvad synes du mads?)
-- return to chest if full and repreat where it left off


-- Things to investigate:
-- Do the tools break? https://computercraft.info/wiki/Turtle.equipRight  does not look like it.
-- Fuel requirement? https://computercraft.info/wiki/Turtle.getFuelLevel coal blocks in the beginning of each run should solve the issue.