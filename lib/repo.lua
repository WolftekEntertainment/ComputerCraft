-- Imports
local utils = require("utils")

-- Private variables
local _host = "github.com"
local _org = "WolftekEntertainment"
local _repository = "ComputerCraft"
local _blacklist = {".gitignore", "README.md"}
local _headers = {
	["Cache-Control"] = "no-cache"
}

-- Module start
local repo = {}

-- Local methods
function getTreeSHAURL(tree)
	return utils.removeQuotations(tree["commit"]["commit"]["tree"]["url"]) .. "?recursive=1"
end

-- Global methods
function repo.fetchCommitTree(branch)
	local url = "https://api." .. _host .. "/repos/" .. _org .. "/" .. _repository .. "/branches/" .. branch
	local req = http.get(url, _headers, false)
	local tree = textutils.unserialiseJSON(req.readAll())
	req.close()
	return tree
end

function repo.listContent(branch)
    local tree = repo.fetchCommitTree(branch)
	local treeURL = getTreeSHAURL(tree)
	local req = http.get(treeURL, _headers, false)
	local src = textutils.unserialiseJSON(req.readAll())
	req.close()
	
	local list = {}
	for i, file in pairs(src["tree"]) do
		if file["type"] == "blob" and not utils.tableContains(_blacklist, utils.removeQuotations(file["path"])) then
			table.insert(list, file["path"])
		end
	end
	return list
end

-- Module end
return repo