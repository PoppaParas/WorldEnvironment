-- @ScriptType: ModuleScript
--!nocheck
--[[
Novus,omni_novus,11/30/25
Index Manager
Handles all indexing and searching
]]

local RepStorage = game:GetService("ReplicatedStorage")

local ObjectIndexes = {}
local SearchManager = {
	ObjectIndexes = ObjectIndexes
}

local SelectObjects = {}
local Indexes = require(RepStorage:WaitForChild("Indexes"))


function AddPrevType<T1,T2>(Index:T1,Index2:T2) :T2 & T1
	if typeof(Index) ~= "table" then return end
	if typeof(Index2) ~= "table" then return end
	type Combined = T2 & T1
	local Index2 = Index2 :: {T2}
	local Index = Index :: {T1}
	for i,v in Index2 do
		Index[i] = v
	end
	Index = Index 
	local Index:Combined = Index
	return Index
end

function SearchManager:FindObject<T1>(Index:T1 )
	local Found:typeof(SearchManager.ObjectIndexes[Index]) = SearchManager.ObjectIndexes[Index]
	return Found
end



function SearchManager:CreateFindIndex<EntryType>(Entry:EntryType) 
	
	local ObjectIndexes =  AddPrevType(ObjectIndexes,Entry)

	return ObjectIndexes
	
end

ObjectIndexes = SearchManager:CreateFindIndex(Indexes)





return SearchManager
