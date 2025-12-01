-- @ScriptType: ModuleScript
local Level1 = script.Level1
local Level2 = script.Level2
local Level3 = script.Level3
local Utils = script.Utils

local SharedSystems = {
	Modules = {
		-- Level1 modules
		IndexManager = require(Level1.IndexManager),
		NetworkManager = require(Level2.NetworkManager),

		-- Level2 modules
		AnimManager = require(Level2.AnimManager),
		EventManager = require(Level2.EventManager),
		Test = require(Level2.Test),
		ThreadManager = require(Level1.ThreadManager),

		-- Utils modules
		Algorithms = require(Utils.Algorithms),
		List = require(Utils.List),
		TableUtil = require(Utils.TableUtil),
		
		DataManager = require(Level3.DataManager)

	}
}

return SharedSystems

