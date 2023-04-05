-- Imports
package.path = package.path .. ";/.system/lib/?.lua"
local sound = require("sound")
local utils = require("utils")
local repo = require("repo")

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

-- "Minecraft/Volume Beta/Aria Math.dfpwm"

local function fetchMusicLibrary()
    local files = repo.listContent("music")

    local library = {}
    for i, file in pairs(files) do
        local urlPrefix = "https://github.com/WolftekEntertainment/ComputerCraft/blob/music/"
        local urlSuffix = "?raw=true"
        local url = urlPrefix .. utils.urlEncode(file) .. urlSuffix

        local song = {}
        song["title"] = string.gsub(string.gsub(file, ".*(.\/)", ""), ".dfpwm", "")
        song["url"] = url
        song["online"] = false

        table.insert(library, song)
    end

    return library
end

local function streamSong(url)
    local req = http.get(url, nil, true)
    local src = req.readAll()
    req.close()
    sound.playFile(src)
end

local function printUsage()
    local programName = args[1] or fs.getName(shell.getRunningProgram())
    print("Plays music discs, usages:")
    print(programName .. " play")
    --print(programName .. " play <drive>")
    print(programName .. " stop")
    print(programName .. " repeat")
end

local library = fetchMusicLibrary()

if #args > 0 then
    if args[1] == "play" then
        --sound.playDisk()
        if #library > 0 then
            local song = library[0]
            print(song["title"])
            streamSong(song["url"])
        end
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