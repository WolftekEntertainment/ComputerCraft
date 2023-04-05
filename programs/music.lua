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

local function printUsage()
    local programName = args[1] or fs.getName(shell.getRunningProgram())
    print("Plays music, usages:")
    print(programName .. " stop")
    print(programName .. " play <url or file>")
end

local library = fetchMusicLibrary()

if #args > 0 then
    if args[1] == "play" then
        if args[2] and #library > 0 then
            for i, song in pairs(library) do
                if song["title"] == args[2] then
                    print("Playing: " .. song["title"])
                    sound.play(song["url"])
                    break
                end
            end
        end
    elseif args[1] == "loop" then
        if #library > 0 then
            while true do
                for i, song in pairs(library) do
                    print("Playing: " .. song["title"])
                    sound.play(song["url"])
                end
            end
        end
    elseif args[1] == "stop" then
        sound.stop()
    else
        printUsage()
    end
else
    printUsage()
end