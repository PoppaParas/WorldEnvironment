-- @ScriptType: Script
local Selection = {}
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
	game:GetService("Lighting"),
	game.StarterPack
}

_G.SelectedScripts = {}

function Added(x:Script)

	if not (x:IsA("Script") or
		x:IsA("ModuleScript") or
		x:IsA("LocalScript")) then
		return
	end
	if table.find(_G.SelectedScripts,x) then return end
	table.insert(_G.SelectedScripts,x)
	x.Destroying:Once(function()
		local Found =  table.find(_G.SelectedScripts,x)
		if Found then return end
		table.remove(_G.SelectedScripts,Found)
	end)

end

for i,v in RelevantServices do
	for e,x:Script in v:GetDescendants() do
		Added(x)
	end
	
end

game:GetService("Selection"):Set(_G.SelectedScripts)

