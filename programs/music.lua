-- Imports
package.path = package.path .. ";/.system/lib/?.lua"
local sound = require("sound")
local utils = require("utils")
local repo = require("repo")

-- Globals
local library = {
    {["title"]="13", ["author"]="C418", ["length"]=178, ["url"]="minecraft:music_disc.13"},
    {["title"]="cat", ["author"]="C418", ["length"]=185, ["url"]="minecraft:music_disc.cat"},
    {["title"]="blocks", ["author"]="C418", ["length"]=345, ["url"]="minecraft:music_disc.blocks"},
    {["title"]="chirp", ["author"]="C418", ["length"]=185, ["url"]="minecraft:music_disc.chirp"},
    {["title"]="far", ["author"]="C418", ["length"]=174, ["url"]="minecraft:music_disc.far"},
    {["title"]="mall", ["author"]="C418", ["length"]=197, ["url"]="minecraft:music_disc.mall"},
    {["title"]="mellohi", ["author"]="C418", ["length"]=96, ["url"]="minecraft:music_disc.mellohi"},
    {["title"]="stal", ["author"]="C418", ["length"]=150, ["url"]="minecraft:music_disc.stal"},
    {["title"]="strad", ["author"]="C418", ["length"]=183, ["url"]="minecraft:music_disc.strad"},
    {["title"]="ward", ["author"]="C418", ["length"]=251, ["url"]="minecraft:music_disc.ward"},
    {["title"]="11", ["author"]="C418", ["length"]=71, ["url"]="minecraft:music_disc.11"},
    {["title"]="wait", ["author"]="C418", ["length"]=238, ["url"]="minecraft:music_disc.wait"},
    {["title"]="pigstep", ["author"]="Lena Raine", ["length"]=148, ["url"]="minecraft:music_disc.pigstep"},
    {["title"]="otherside", ["author"]="Lena Raine", ["length"]=195, ["url"]="minecraft:music_disc.otherside"},
    {["title"]="5", ["author"]="Samuel Åberg", ["length"]=178, ["url"]="minecraft:music_disc.5"}
}

args = { ... }

-- "Minecraft/Volume Beta/Aria Math.dfpwm"

local function appendMusicLibrary()
    local files = repo.listContent("music")

    for i, file in pairs(files) do
        local urlPrefix = "https://github.com/WolftekEntertainment/ComputerCraft/blob/music/"
        local urlSuffix = "?raw=true"
        local url = urlPrefix .. utils.urlEncode(file) .. urlSuffix

        local song = {}
        song["title"] = string.gsub(string.gsub(file, ".*(.\/)", ""), ".dfpwm", "")
        song["url"] = url
        song["online"] = true

        table.insert(library, song)
    end
end

local function printUsage()
    local programName = args[1] or fs.getName(shell.getRunningProgram())
    print("Plays music, usages:")
    print(programName .. " stop")
    print(programName .. " play <url or file>")
end

appendMusicLibrary()

if #args > 0 then
    if args[1] == "play" then
        if args[2] and #library > 0 then
            for i, song in pairs(library) do
                if string.lower(song["title"]) == string.lower(args[2]) then
                    print("Playing: " .. song["title"])
                    sound.play(song["url"])
                    return
                end
            end
            print("Could not find song " .. args[2])
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