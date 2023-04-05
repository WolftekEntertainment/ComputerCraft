-- Module start
local utils = {}

-- Local methods
local charToHex = function(c)
	return string.format("%%%02X", string.byte(c))
end

-- Global methods
function utils.removeQuotations(text)
	local text_replaced = string.gsub(text, "\"", "")
	return text_replaced
end

function utils.urlEncode(url)
	if url == nil then return end
	url = string.gsub(url, "([' '])", charToHex)
	return url
end

function utils.tableContains(table, entry)
	for i, item in pairs(table) do
		if item == entry then return true end
	end
	return false
end

-- Module end
return utils