-- Arguments
local args = { ... }

-- Globals
local _host = "https://cloudn.dk:7990"
local _project = "MC_CC"
local _branch = "master"

local _blacklist = {".gitignore", "README.md"}

-- Set workspace folder
local workspace_path = "/.system"

-- Check installation
if not args[0] == "skipreboot" then
	print("Loading from disk..")
	if fs.isDir(workspace_path) then
		io.write("System found, reinstall OS? (Y/N): ")
	else
		io.write("No system found, install OS? (Y/N): ")
	end
	while true do
		local answer = io.read()
		if answer == "Y" or answer == "y" then
			break
		elseif answer == "N" or answer == "n" then
			return
		else
			io.write("Invalid input, try again: ")
		end
	end
end

-- Starting
print("Starting Installation...")

-- Clear terminal
--dir_path = fs.getDir(shell.getRunningProgram()) --Find path to disk
shell.run("cd /") -- Goes into root
shell.run("clear")

-- Cleanup workspace
local workspace_abs_path = shell.resolve(workspace_path)
if fs.exists(workspace_abs_path) then
	print("Deleting old files...")
	fs.delete(workspace_abs_path)
end
shell.run("mkdir " .. workspace_path)
shell.run("cd " .. workspace_path)

-- Download, default is silent download
-- url = HTTP source, file_abs_path = absolute path of file
function download(url, file_abs_path, verbose)
	verbose = verbose or false -- defaults to false if left unspecified
	
	if verbose then print("Downloading " .. file_abs_path .. "...") end
	
	-- Check if URL is valid
	local ok, err = http.checkURL(url)
	if verbose and not ok then
		print("Invalid URL: " .. url)
		return
	end
	
	-- Get response
	local response = http.get(url , nil , true) -- use binary
    if verbose and not response then
        print("Failed to get response: " .. url)
        return nil
    end

	-- Check if file exists, overwrite
	if fs.exists(file_abs_path) then
		if verbose then print("File " .. file_abs_path .. " already exists, overwriting..") end
		fs.delete(file_abs_path)
	end

	-- Save response
	local res = response.readAll()
    response.close()
    
	local file, err = fs.open(file_abs_path, "wb")
    if verbose and not file then
        printError("Cannot save file: " .. err)
        return
    end

    file.write(res)
    file.close()

	if verbose then print("Download complete!") end
end

-- Fetch OS Files from git API
-- Example: {"values":[".gitignore","README.md","archive.txt","install/config.txt","install/startup.lua","install/startup_utils.lua","os.lua","test.lua"],"size":8,"isLastPage":true,"start":0,"limit":25,"nextPageStart":null}
function fetch_repo_filepaths(repo)
	local req = http.get(_host .. "/rest/api/1.0/projects/" .. _project .. "/repos/" .. repo .. "/files?branch=" .. _branch)
	local src = textutils.unserialiseJSON(req.readAll())
	req.close()
	
	local list = {}
	for i, file in pairs(src["values"]) do
		table.insert(list, file)
	end
	return list
end

-- Construct final url based on repository and filename
function get_url(repo, file_path)
	return _host .. "/projects/" .. _project .. "/repos/" .. repo .."/raw/"
		.. file_path
		.. "?at=refs%2Fheads%2F"
		.. _branch
end

-- Generic table contains function to compare if entry exists in table
function table_contains(table, entry)
	for i, item in pairs(table) do
		if item == entry then return true end
	end
	return false
end

function create_startup()
	local file = fs.open("startup.lua", "w")
	file.write("shell.run('/.system/os.lua')")
	file.close()
end

-- Installation
local file_paths = fetch_repo_filepaths("os")
for i, file_path in pairs(file_paths) do
	if not table_contains(_blacklist, file_path) then
		local file_path_abs = workspace_abs_path .. "/" .. file_path
		download(get_url("os", file_path), file_path_abs)
	end
end

-- Setup system settings
settings.set("shell.allow_disk_startup", false)
settings.set("list.show_hidden", true)
settings.save()

-- Add startup script to root for boot into OS
create_startup()

print("Installation completed!")
print("Restarting system...")
sleep(1)
os.reboot()