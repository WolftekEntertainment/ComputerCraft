local gui = require("gui")

if(term.isColor() == true) then
    gui.Home()
    gui.Actions()
else
    gui.Terminal()
end