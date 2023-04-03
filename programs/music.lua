-- Imports
package.path = package.path .. ";/.system/lib/?.lua"
local sound = require("sound")

-- Globals
songsLength = {
    ["C418 - 13"]=178,
    ["C418 - cat"]=185,
    ["C418 - blocks"]=345,
    ["C418 - chirp"]=185,
    ["C418 - far"]=174,
    ["C418 - mall"]=197,
    ["C418 - mellohi"]=96,
    ["C418 - stal"]=150,
    ["C418 - strad"]=183,
    ["C418 - ward"]=251,
    ["C418 - 11"]=71,
    ["C418 - wait"]=238,
}

args = { ... }

local function printUsage()
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Plays music discs, usages:")
    print(programName .. " play")
    --print(programName .. " play <drive>")
    print(programName .. " stop")
    print(programName .. " repeat")
end

if #args > 0 then
    if args[1] == "play" then
        sound.playDisk()
    elseif args[1] == "stop" then
        sound.stop()
    elseif args[1] == "repeat" then
        while true do
            local drive = sound.findDisk()
            local songName = drive.getAudioTitle()
            local playTime = songsLength[songName]
            sound.playDisk(drive)
            os.sleep(playTime)
        end
    else
        printUsage()
    end
else
    printUsage()
end