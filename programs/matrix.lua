local width, height = term.getSize()

local str = string.rep(" ", width)

print(str)

while true do
    -- Allow infinite while loop (Yield issue) --
    os.queueEvent("matrixEvent")
    os.pullEvent()
    ---------------------------------------------

    str_new = ""
    for i = 1, #str do
        local c = str:sub(i, i)
        local num = math.random(0, 255)
        if num < 180 and i % 2 == 0 then
            local num_new = (string.byte(c) + num) % 256
            str_new = str_new .. string.char(num_new)
        elseif num > 220 then
            str_new = str_new .. " "
        else
            str_new = str_new .. c
        end

        
    end
    
    term.setTextColor(colors.green)
	term.setBackgroundColor(colors.black)
    print(str_new)
    str = str_new

    sleep(0.05)
end