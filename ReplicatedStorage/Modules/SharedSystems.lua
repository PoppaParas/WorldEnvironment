-- @ScriptType: ModuleScript
local Indexes = require(game.ReplicatedStorage.Indexes)

local Level1 = script.Level1
local Level2 = script.Level2

local SharedSystems = {
	Level1 = {
		IndexManager = require(Level1.IndexManager),
		Test = require(Level1.Test)
	},
	Level2 = {
		
	}
}

SharedSystems.Level1.Test("Hi")


return SharedSystems
