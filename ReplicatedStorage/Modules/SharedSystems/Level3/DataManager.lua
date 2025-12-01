-- @ScriptType: ModuleScript
--!nocheck
--[[
Novus,omni_novus, 11/30/25
DataManager
Handles data manipulation, reading, saving, etc.
]]

local Libraries = script.Parent.Parent

local Utils = Libraries.Utils
local Level1 = Libraries.Level1
local Level2 = Libraries.Level2

local ListManager = require(Utils.List)
local TableUtil = require(Utils.TableUtil)

local ObjectList:ListManager.ListObjectType<Instance,DataObject<Instance>> = ListManager.new()

local DataManager = {
	Config = {}
}

local DataObject = {}
DataObject.__index = DataObject
local Data = require(script.Data)

export type DataObject<T1> = {
	Data:typeof(Data),
	Object:T1
} & typeof(DataObject.__index)








DataManager.Config = setmetatable(DataManager.Config,{
	__index = Data
})  
if true then
	for i,v in Data do
		DataManager.Config[i] = v
	end
end



function CreateDataObject<T1,T2>(Object:T1,Override:T2)
	
	local New:{
		Data:T2	
	} & DataObject<T1>  = {
		Data = Override,
		Object = Object
	}
	TableUtil:Overwrite(New.Data,DataManager.Config)
	local New:typeof(New) = New
	return New
	
end


function DataManager.new<T1,T2>(Object:T1,Override:T2 & Data)
	local List = ObjectList:Find(Object)
	if not List then
		local NewList = CreateDataObject(Object,Override)
		ObjectList:Set(Object,NewList)
		List = NewList :: typeof(NewList)
	else
		TableUtil:Overwrite(List.Data,Override) 
		List = List :: {
			Data:T2 & typeof(List.Data)
		} & typeof(List)
	end
	
	
	return List
end


type DataManager = typeof(DataManager) & {
	Config:typeof(Data)
}

local DataManager:DataManager = DataManager

return DataManager
