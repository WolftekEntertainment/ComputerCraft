-- Imports
package.path = package.path .. ";/.system/lib/?.lua"
local sound = require("sound")
local utils = require("utils")
local repo = require("repo")

-- Globals
local width, height = term.getSize()
local libraryPath = "/.system/lib/musiclibrary.txt"
local library = nil

args = { ... }

local function getMusicLibrary()
    local files = repo.listContent("music")

    local library = {
        {["title"]="13", ["author"]="C418", ["duration"]=178, ["url"]="minecraft:music_disc.13"},
        {["title"]="Cat", ["author"]="C418", ["duration"]=185, ["url"]="minecraft:music_disc.cat"},
        {["title"]="Blocks", ["author"]="C418", ["duration"]=345, ["url"]="minecraft:music_disc.blocks"},
        {["title"]="Chirp", ["author"]="C418", ["duration"]=185, ["url"]="minecraft:music_disc.chirp"},
        {["title"]="Far", ["author"]="C418", ["duration"]=174, ["url"]="minecraft:music_disc.far"},
        {["title"]="Mall", ["author"]="C418", ["duration"]=197, ["url"]="minecraft:music_disc.mall"},
        {["title"]="Mellohi", ["author"]="C418", ["duration"]=96, ["url"]="minecraft:music_disc.mellohi"},
        {["title"]="Stal", ["author"]="C418", ["duration"]=150, ["url"]="minecraft:music_disc.stal"},
        {["title"]="Strad", ["author"]="C418", ["duration"]=183, ["url"]="minecraft:music_disc.strad"},
        {["title"]="Ward", ["author"]="C418", ["duration"]=251, ["url"]="minecraft:music_disc.ward"},
        {["title"]="11", ["author"]="C418", ["duration"]=71, ["url"]="minecraft:music_disc.11"},
        {["title"]="Wait", ["author"]="C418", ["duration"]=238, ["url"]="minecraft:music_disc.wait"},
        {["title"]="Pigstep", ["author"]="Lena Raine", ["duration"]=148, ["url"]="minecraft:music_disc.pigstep"},
        {["title"]="Otherside", ["author"]="Lena Raine", ["duration"]=195, ["url"]="minecraft:music_disc.otherside"},
        {["title"]="5", ["author"]="Samuel �berg", ["duration"]=178, ["url"]="minecraft:music_disc.5"}
    }

    for i, file in pairs(files) do
        local urlPrefix = "https://github.com/WolftekEntertainment/ComputerCraft/blob/music/"
        local urlSuffix = "?raw=true"
        local url = urlPrefix .. utils.urlEncode(file) .. urlSuffix

        local song = {}
        local filename = string.gsub(string.gsub(file, ".*(.\/)", ""), ".dfpwm", "")
        song["author"], song["title"] = string.match(filename, "(.*)%W%-%W(.*)")
        song["url"] = url

        -- Get duration
        local req = http.get(url, nil, true)
        song["duration"] = req.getResponseHeaders()["content-length"] * 8 / 48000 -- 8 bit depth and 48.000 samplerate
        req.close()

        table.insert(library, song)
    end

    return library
end

local function syncMusicLibrary()
    print("Syncing music library...")
    print("Downloading music library...")
    local newLibrary = getMusicLibrary()
        
    print("Saving...")
    if fs.exists(libraryPath) then fs.delete(libraryPath) end

    local file = fs.open(libraryPath, "w")
    file.write(textutils.serialize(newLibrary))
    file.close()

    library = newLibrary
    print("Syncing complete!")
end

local function loadMusicLibrary()
    if fs.exists(libraryPath) then
        local file = fs.open(libraryPath, "r")
        library = textutils.unserialize(file.readAll())
        file.close()
    else
        print("No music library found..")
        syncMusicLibrary()
    end
end

local function playSong(song)
    shell.run("clear")
    local m = math.floor(song["duration"] / 60)
    local s = math.floor(song["duration"] - m * 60)
    local length = string.format("%d", m) .. ":" .. string.format("%02d", s)
    print("Playing: " .. song["author"] .. " - " .. song["title"])
    print("Duration: " .. length)
    parallel.waitForAll(
        function()
            local progressBar = string.rep("#", width - 1)
            textutils.slowPrint(progressBar, #progressBar / song["duration"])
        end,
        function()
            sound.play(song["url"], song["duration"])
        end
    )
end

local function printUsage()
    local programName = args[1] or fs.getName(shell.getRunningProgram())
    print("Plays music, usages:")
    print(programName .. " play <url or file>")
    print(programName .. " loop")
    print(programName .. " stop")
    print(programName .. " sync")
end

if #args > 0 then
    if args[1] == "play" then
        if args[2] then
            if not library then loadMusicLibrary() end

            if #library > 0 then
                for i, song in pairs(library) do
                    if string.lower(song["title"]) == string.lower(args[2]) then
                        playSong(song)
                        return
                    end
                end
                print("Could not find song " .. args[2])
            end
        end
    elseif args[1] == "loop" then
        if not library then loadMusicLibrary() end

        if #library > 0 then
            while true do
                for i, song in pairs(library) do
                    playSong(song)
                end
            end
        end
    elseif args[1] == "stop" then
        sound.stop()
    elseif args[1] == "sync" then
        syncMusicLibrary()
    else
        printUsage()
    end
else
    printUsage()
end