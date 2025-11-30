-- @ScriptType: ModuleScript
local WorldObject = script.Parent.Parent

local Util = WorldObject.Util

local ModuleGetter = {}
local ModuleObject = {}
ModuleObject.__index = ModuleObject

function ModuleGetter:RegisterModule<T>(Module:T)
	
	
end

return ModuleGetter
