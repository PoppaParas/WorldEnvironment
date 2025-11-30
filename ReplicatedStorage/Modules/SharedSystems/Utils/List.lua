-- @ScriptType: ModuleScript
local List = {}




function DeepClone<T1>(Table:T1):T1
	assert(Table,`No Valid Table`)
	Table = table.clone(Table)
	for i,v in Table do
		if type(v) == "table" then
			Table[i] = DeepClone(v)
		end
	end
	return Table
end

local ListObject = {

}
ListObject.__index = ListObject
ListObject.__Mode = "v"

--@private
type DefaultListType = {
	IsArray:boolean?,
	Index:string,
	Destroyed:boolean,
	Length:number
}

export type ListObjectTypeAlone<T1> = {
	Objects:T1,

	ReplaceFunc:(Index:any,Value:any,OldValue:any)->(),
}& typeof(ListObject) & DefaultListType
export type ListObjectType<T1,T2> = {
	Objects:{[T1]:T2},
	ReplaceFunc:(Index:T1,Value:T2,OldValue:T2)->(),
} & typeof(ListObject) & DefaultListType




local Lists:{
	[string]:typeof(ListObject)} = {}




function CreateNewList<T1,T2>():ListObjectType<T1,T2>
	local New = setmetatable({
		Objects = {},
		IsArray = false,
		Index = "",
		Destroyed = false,
		ReplaceFunc = function(Index:T1,Value:T2,OldValue:T2)

		end,
		Length = 0
	}, ListObject) 


	return New
end

function List.new<Index,Value>(InitializerList:{[Index]:Value}?,Array:boolean?):ListObjectType<Index,Value>
	local NewList:ListObjectType<Index,Value> = CreateNewList()
	NewList.IsArray = Array or false

	if not InitializerList then return NewList end
	if not NewList.IsArray then
		for i,v in InitializerList do
			NewList[i] = v
			NewList.Length += 1
		end
	else
		for i = 1, #InitializerList do
			NewList[i] = InitializerList[i]
			NewList.Length += 1
		end
	end
	return NewList
end


function ListObject:Find(Index)
	
	return self.Objects[Index]
end
--@private
function ListObject._SetReplacementFunc<SelfType,T1,T2>(self:SelfType,Func:(Index:T1,Value:T2,OldValue:T2)->())
	if type(Func) == "function" then 
	self.ReplaceFunc = Func
	return self
	end
	return self
end

function ListObject:SetReplacementFunc<SelfType,T1,T2>(self:SelfType,Func:(Index:T1,Value:T2,OldValue:T2)->())
	
end

function ListObject._Set<SelfType,T1,T2>(self:SelfType,Index:T1,Value:T2)
	
	local OldValue = self.Objects[Index]
	if OldValue ~= nil then

		self.Length += Value == nil and -1 or 1
	end
	self.Objects[Index] = Value
	if self.ReplaceFunc then
		task.spawn(self.ReplaceFunc,Index,Value,OldValue)
	end
	local self:typeof(self) = self
	return self

end
function ListObject:Set<T1,T2>(Index:T1,Value:T2)
	local Ret = ListObject._Set(self,Index,Value)
	local self : typeof(Ret) = self
	
	return self
end

--@private
function ListObject._Append<SelfType,T2>(self:SelfType,Values:T2)
	if typeof(Values) == "table" then
		
		local self:SelfType & ListObjectTypeAlone<typeof(self.Objects)> = self
		for i,v in Values do
			self:Set(i,v)
		end
		local Objects:typeof(self.Objects) & typeof(Values) = self.Objects
		self.Objects = Objects
		local self:typeof(self) = self
		return self
	end
	return self


end


function ListObject:Append<T2>(Values:T2)

	
	local NewSelf = ListObject._Append(self,Values)
	
	local self:typeof(NewSelf) = NewSelf
	
	return self

end

function ListObject:Insert<T2>(Value:T2,Index:number?)
	
	if not self.IsArray then return end

	if Index then self:Set(Index,Value) return end

	self.Length += 1
	table.insert(self.Objects,Value)
end

function ListObject:Remove<T1>(Index:T1)
	self.Objects[Index] = nil
	local self:typeof(self) = self
	return self
end


function ListObject:GetSize()
	local Amnt = 0
	
end

function ClearList<T1,T2>(Table:{[T1]:T2})
	for i,v in Table do
		if typeof(v) == "table" then
			ClearList(v)
		end
	end
	table.clear(Table)
end

--@private
function ListObject._Clear<SelfType>(self:SelfType)
	ClearList(self.Objects)
	return self
end
function ListObject:Clear()
	local NewSelf = ListObject._Clear(self)
	local self:typeof(self) = NewSelf
	
	return self
end


function ListObject:Destroy()

	self:Clear()
	table.clear(self)
	self.Destroyed = true
	local self:typeof(self) = self
	return self


end

return List
