-- Imports
local sound = require("lib/sound")

-- Globals
local width, height = term.getSize()
local os_colors = {
	bg = colors.white,
	text = colors.black
}
local os_sounds = {
	startup = ".system/sounds/startup.dfpwm",
	shutdown = ".system/sounds/shutdown.dfpwm",
	logon = ".system/sounds/logon.dfpwm",
	logoff = ".system/sounds/logoff.dfpwm"
}

function centerPos(w, h)
	-- Will return center pos (top left) for object with w and h
	local x = math.floor((width - w) / 2)
	local y = math.floor((height - h) / 2)
	return x, y
end

function showSplash()
	-- Prep the splash screen
	term.clear()
	--paintutils.drawFilledBox(0, 0, width, height, os_colors["bg"]) -- Set bg
	local wallpaper = paintutils.loadImage(".system/images/wallpaper.nfp")
	paintutils.drawImage(wallpaper, 1, 1) -- Set bg
	term.setTextColor(os_colors["text"])
	term.setBackgroundColor(os_colors["bg"])

	-- Write welcome message
	local message = "Welcome to OS"
	local x, y = centerPos(string.len(message), 1)
	term.setCursorPos(x, y)
	term.write(message)

	-- Play startup/boot sound
	sound.playFile(os_sounds["startup"])

	-- Await splash finish
	os.sleep(3)

	-- Play logon sound
	sound.stop()
	sound.playFile(os_sounds["logon"])
end

function setupAliases()
	shell.setAlias("nano", "edit")
	shell.setAlias("commands", "/.system/commands.lua")
	shell.setAlias("uninstall", "/.system/uninstall.lua")
	shell.setAlias("update", "/.system/update.lua")
	shell.setAlias("env", "/.system/env.lua")
	shell.setAlias("music", "/.system/programs/music.lua")
end

-- Return to terminal
function resetTerminal()
	paintutils.drawFilledBox(0, 0, width, height, colors.black)
	term.setCursorPos(1, 1)
	term.setTextColor(colors.white)
	term.setBackgroundColor(colors.black)
	shell.run("cd /")
	term.clear()
end

-- Run
showSplash()
setupAliases()
resetTerminal()