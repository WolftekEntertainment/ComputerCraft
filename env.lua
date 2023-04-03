local s = settings.getNames()

for i, k in pairs(s) do
    local val = textutils.serialize(settings.get(k))
    print(i .. ": " .. k .. ": " .. val)
end