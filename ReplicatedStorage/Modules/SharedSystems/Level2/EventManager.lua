-- @ScriptType: ModuleScript

local Modules = script.Parent.Parent

local Level1 = Modules.Level1
local Utils = Modules.Utils

local ThreadManager = require(Level1.ThreadManager)
local IndexManager = require(Level1.IndexManager)

local TableUtil = require(Utils.TableUtil)

local EventManager = {}
local EventObject = {}
EventObject.__index = EventObject

--@private
type DefaultArg = ()->()

--@private
type DefaultFunc = ()->()

--@private
type DefaultEventList = {

}

export type Event<Args,Func> = {
	Args:Args|DefaultArg,
	Func:Func|DefaultFunc
}
export type EventObject<EventList,Args,Func> = {
	List:EventList,

}


export type DefaultEventObject = EventObject<DefaultEventList,
DefaultArg,DefaultFunc>

local DefaultArgsFunc:DefaultArg = function()

end 

function EventManager.new<EventList>(List:EventList)
	local self = setmetatable({}, EventObject)
	local NewList:EventList = TableUtil:Clone(List)
	self.List = NewList
	local self:typeof(self) = self
	return self
end


function ValidateEventCreation<T2,T3>(Func:T2,ReturnArgs:T3|DefaultArg)
	if typeof(Func) ~= "function" then return end
	if typeof(ReturnArgs) ~= "function" and typeof(ReturnArgs) ~= "nil" then return end
return true
end

function EventManager.CreateEvent<T2,T3>(Func:T2,ReturnArgs:T3|DefaultArg)
	if ValidateEventCreation(Func,ReturnArgs) then 
	type NewArg = T3|DefaultArg
	if not ReturnArgs then
		ReturnArgs = DefaultArgsFunc
	end
	local Event:Event<T3,T2> = {
		Args = ReturnArgs,
		Func = Func
	}
	return Event
	end
end






--@private
function EventObject._CreateEvent<SelfType,T1,T2,T3>(self:SelfType,EventName:T1,Func:T2,ReturnArgs:T3|DefaultArg)
	if ValidateEventCreation(Func,ReturnArgs) then
	local self:SelfType = self
	local Event = EventManager.CreateEvent(Func,ReturnArgs)
	
	
	
	self.List[EventName] =  Event
	local List:typeof(self.List) = self.List
	self.List = List
	

	
	local self : typeof(self) = self
	
	
	return self
	end
	return self 
end
function EventObject:CreateEvent<T1,T2,T3>(EventName:T1,Func:T2,ReturnArgs:T3|DefaultArg)
	local NewObject = EventObject._CreateEvent(self,EventName,Func,ReturnArgs)
	local self:typeof(NewObject) = NewObject
	return self
end

--@private
function EventObject._Fire<SelfType, EventNameType>(
	self: SelfType,
	EventName: EventNameType
)
	--if typeof(self.List) == "table" then
	type ListType = typeof(self.List)
	
	if self.List[EventName] then
		local Event = self.List[EventName]
		return ThreadManager:CreateThread(nil,function()

			return self.List[EventName].Func(self.List[EventName].Args())
		end)
	end
	--end
	local self:typeof(self) = self
	return self

end
function EventObject:Fire<T1>(EventName:T1)

	return EventObject._Fire(self,EventName)
end

--@private
function EventObject._Append<SelfType,T1>(self:SelfType,Funcs:T1)
	if typeof(Funcs) == "table" then
		--local self:DefaultEventObject & typeof(self) = self
		for i,v in Funcs do
			self.List[i] = v 
		end
		
		local List:typeof(self.List) = self.List
		self.List = List
		local self : typeof(self) & {List:T1} = self


		return self
	end
	return self
end
function EventObject:Append<T1>(Funcs:T)
	local NewObject = EventObject._Append(self,Funcs)
	local self:typeof(NewObject)  = NewObject
	
	return self
end

return EventManager
