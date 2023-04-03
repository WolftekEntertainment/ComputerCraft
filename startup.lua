local currFloorEntry = "bottom"
local dstFloorEntry = "left"
local activateButtonEntry = "top"
local reverseEntry = "right"
local clutchEntry = "back"
local callButtonEntry = "front"

local currFloor = 0
local dstFloor = 0
local goingUp = false
local goingDown = false
local dstReached = false

function updateCurrFloor()
   local readFloor = redstone.getAnalogInput(currFloorEntry)
   if (readFloor ~= 0) then
      currFloor = 15-readFloor
   end
end

function updateDstFloor()
   if (redstone.getInput(activateButtonEntry)) then
      dstFloor = redstone.getAnalogInput(dstFloorEntry)
      return
   end
   local callButtonVal = redstone.getAnalogInput(callButtonEntry) 
   if (callButtonVal ~= 0) then
      dstFloor = 15-callButtonVal
   end
end

function getFloorDiff()
   return dstFloor - currFloor
end

redstone.setOutput(clutchEntry, false)
redstone.setOutput(reverseEntry, true)
while true do
   os.pullEvent("redstone")
   updateDstFloor()
   updateCurrFloor()
   local floorDiff = getFloorDiff()
   if (floorDiff == 0
    and redstone.getAnalogInput(currFloorEntry) ~= 0
    and dstReached == false) then
      print("destination reached")
      redstone.setOutput(clutchEntry, true)
      dstReached = true
      goingUp = false
      goingDown = false
   elseif (floorDiff > 0 and goingDown == false) then
      print("going down")
      redstone.setOutput(clutchEntry, false)
      redstone.setOutput(reverseEntry, false)
      dstReached = false
      goingUp = false
      goingDown = true
   elseif (floorDiff < 0 and goingUp == false) then
      print("going up")
      redstone.setOutput(clutchEntry, false)
      redstone.setOutput(reverseEntry, true)
      dstReached = false
      goingUp = true
      goingDown = false 
   end    
end

