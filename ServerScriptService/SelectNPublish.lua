-- @ScriptType: ModuleScript
-- @ScriptType: Script
-- Plugin: Select all scripts in common services on button click

local SelectionService = game:GetService("Selection")

local RelevantServices = {
	game.ReplicatedFirst,
	game.ReplicatedStorage,
	game.ServerScriptService,
	game.StarterGui,
	game.StarterPlayer,
	game.StarterPlayer.StarterCharacterScripts,
	game.StarterPlayer.StarterPlayerScripts,
	game.Workspace,
	game.Players,
	workspace,
	game.ServerStorage,
	game:GetService("Lighting"),
	game.StarterPack,
}

-- Optional: keep this global if you want to inspect it from the command bar
_G.SelectedScripts = _G.SelectedScripts or {}

local function Added(x: Instance)
	if not (x:IsA("Script") or x:IsA("ModuleScript") or x:IsA("LocalScript")) then
		return
	end

	if table.find(_G.SelectedScripts, x) then
		return
	end

	table.insert(_G.SelectedScripts, x)

	x.Destroying:Once(function()
		local idx = table.find(_G.SelectedScripts, x)
		if not idx then
			return
		end
		table.remove(_G.SelectedScripts, idx)
	end)
end

local function CollectAndSelect()
	-- reset the list each click so it reflects current state
	table.clear(_G.SelectedScripts)

	for _, service in ipairs(RelevantServices) do
		if service then
			for _, inst in ipairs(service:GetDescendants()) do
				Added(inst)
			end
		end
	end

	SelectionService:Set(_G.SelectedScripts)
end

----------------------------------------------------------------
-- PLUGIN UI
----------------------------------------------------------------

local toolbar = plugin:CreateToolbar("Script Tools")

local selectButton = toolbar:CreateButton(
	"SelectAllScripts",
	"Select all scripts in common services",
	"rbxassetid://0" -- replace with your icon asset id if you want
)

selectButton.Click:Connect(function()
	CollectAndSelect()
end)
