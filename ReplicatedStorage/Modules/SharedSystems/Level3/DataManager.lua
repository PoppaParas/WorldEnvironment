-- @ScriptType: ModuleScript
--!nocheck
--[[
Novus,omni_novus, 11/30/25
DataManager
Handles data manipulation, reading, saving, etc.
]]

local DataManager = {
	Config = {}
}

local DataObject = {}
DataObject.__index = DataObject






local Data = require(script.Data)



DataManager.Config = setmetatable(DataManager.Config,{
	__index = Data
})  
if true then
	for i,v in Data do
		DataManager.Config[i] = v
	end
end

type DataManager = typeof({
	Config = Data}) & typeof(DataManager)
local DataManager = DataManager :: DataManager


return DataManager
