-- Globals
local _width, _height = term.getSize()

-- Lib var for return
local gui = {}

-- Return to GUI
function gui.Home()
	-- Wallpaper --  
	term.clear()
	local home = paintutils.loadImage(".system/images/home.nfp")
	paintutils.drawImage(home, 1, 1)
	
	-- Menu --
	term.setTextColor(colors.black)
	term.setBackgroundColor(colors.gray)
	term.setCursorPos(1, 1)
	term.clearLine()
	print("[OS]   [Terminal]")
end

-- Handle Clicking on GUI
function gui.Actions()
	while true do
		event, button, x, y = os.pullEvent("mouse_click")
		
		if(button == 1) then
			-- Click on [OS] --
			if(y == 1 and x >= 1 and x <= 4) then
				--return
			end   

			-- Click on [Terminal] --
			if(y == 1 and x >= 8 and x <= 17) then
				gui.Terminal()
				return
			end   
		end
	end
end

-- Terminal
function gui.Terminal()
	paintutils.drawFilledBox(0, 0, _width, _height, colors.black)
	term.setCursorPos(1, 1)
	term.setTextColor(colors.white)
	term.setBackgroundColor(colors.black)
	shell.run("cd /")
	term.clear()
end

return gui