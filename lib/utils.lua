-- Module start
local utils = {}

function utils.removeQuotations(text)
	local text_replaced = string.gsub(text, "\"", "")
	return text_replaced
end

local charToHex = function(c)
	return string.format("%%%02X", string.byte(c))
end

local function utils.urlEncode(url)
	if url == nil then return end
	url = string.gsub(url, "([' '])", charToHex)
	return url
end

-- Module end
return utils