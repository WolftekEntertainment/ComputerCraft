-- Imports
local dfpwm = require("cc.audio.dfpwm")

local sound = {}

function sound.getSpeakers(name)
    name = name or nil
    if name then
        local speaker = peripheral.wrap(name)
        if speaker == nil or not peripheral.hasType(name, "speaker") then
            return
        end
        return {speaker}
    else
        local speakers = {peripheral.find("speaker")}
        if #speakers == 0 then return end
        return speakers
    end
end

function sound.play(file, duration, speaker)
    speaker = speaker or peripheral.find("speaker")
    if not speaker then return end
    duration = duration or nil

    local handle, err, disc
    if http and file:match("^https?://") then
        -- Online file, read as binary
        handle, err = http.get(file, nil, true)
    elseif file:match("^minecraft:") then
        -- Minecraft sound, play ordinarily
        disc = true
    else
        -- Local file, read as binary
        handle, err = fs.open(file, "rb")
    end

    if not handle and not disc then
        printError("Could not play audio:")
        error(err, 0)
    end

    if disc then
        speaker.playSound(file)
        sleep(duration)
        return
    end

    local decoder = dfpwm.make_decoder()
    while true do
        local chunk = handle.read(16 * 1024)
        if not chunk then break end

        local buffer = decoder(chunk)
        while not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end
    end

    handle.close()
end

function sound.findDisk()
    local drive
    drives = {}
    for i, d in pairs(peripheral.getNames()) do
        if disk.isPresent(d) and disk.hasAudio(d) then
            table.insert(drives, d)
        end
    end
    if #drives == 0 then return else
        drive = drives[1]
    end
    return drive
end

function sound.playDisk(drive, speaker)
    speaker = speaker or peripheral.find("speaker")
    if not speaker then return end

    drive = drive or nil
    if not drive then
        drive = sound.findDisk()
    end

    -- Play music from disk
    if disk.isPresent(drive) and disk.hasAudio(drive) then
        disk.playAudio(drive)
    end
end

function sound.stop(speaker)
    speaker = speaker or nil

    if speaker then
        speaker.stop()
    else
        local speakers = sound.getSpeakers()
        if speakers then
            for i, speaker in pairs(speakers) do
                speaker.stop()
            end
        end
    end
end

function sound.playYoutube(videoURL, type, bitrate)
    -- Default parameters
    type = type or "mp3"
    bitrate = bitrate or "64"

    -- URL to locate file download link
    local url = "https://api.vevioz.com/api/widget/"
    local pattern = 'vevioz.com/download/'..videoURL..'/'..type..'/'..bitrate..'.*</a>'

    -- Compose URL
    url = url..type..'/'..videoURL

    -- First request, html to get file link
    local req = http.get(url, nil, false) -- binary = false
    local response = req.readAll()
    req.close()

    -- Locate snippet with file link
    local i, j = string.find(response, pattern)
    local snippet = string.sub(response, i - 22, i + 118) -- Offset to wrap link

    i, j = string.find(snippet, 'href=".*"')
    local url_download = string.sub(snippet, i + 6, j - 1) -- Finalization of download link

    -- Request file (in binary format, true)
    --print("Downloading " .. url_download)
    --local req_down = http.get(url_download, nil, true)
    --response = req_down.readAll()
    --req_down.close()
end

return sound