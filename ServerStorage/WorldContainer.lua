-- @ScriptType: ModuleScript
-- @ScriptType: ModuleScript

local Internals = script.Internals

local Core = Internals.Core
local Util = Internals.Util
local Base = Internals.Base

local UtilLevel2 = Util.Level2

local Container = require(Base.ContainerManager)
local FunctionStack = require(UtilLevel2.FunctionStack)

local StackObject = FunctionStack:Register({
	Lol = function()
		
	end,
})


local StackObject2 = StackObject:Register({
	Lol2 = function()
		
	end,
})

local StackObject3 = StackObject2:Register({
	SuperMarioBros = function()
		
	end,
})






local WorldManager = {}

export type WorldPlayConfig = {
	DebugMode:boolean?
}
local WorldConfigDefault = {}


function WorldManager:Play(Config)
	
end


return WorldManager
