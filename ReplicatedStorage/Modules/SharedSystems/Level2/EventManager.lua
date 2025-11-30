-- @ScriptType: ModuleScript
--[[
Novus, omni_novus, 11/30/25
EventManager
Handles event firing and such.
]]

--Instances
local Modules = script.Parent.Parent

local Level1 = Modules.Level1
local Utils = Modules.Utils

local ThreadManager = require(Level1.ThreadManager)
local IndexManager = require(Level1.IndexManager)

local TableUtil = require(Utils.TableUtil)

local EventManager = {}
local EventObject = {}
EventObject.__index = EventObject

--Types


--@private
type DefaultArg = ()->()

--@private
type DefaultFunc = ()->()

--@private
type DefaultEventList = {

}

export type Event<Args,Func> = {
	Args:Args|DefaultArg,
	Func:Func|DefaultFunc,
	Waiting:{thread}
}
export type EventObject<EventList,Args,Func> = {
	List:EventList,
	

}


export type DefaultEventObject = EventObject<DefaultEventList,
DefaultArg,DefaultFunc>

export type DefaultEvent = Event<
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
		Func = Func,
		Waiting = {}
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
		local Event:DefaultEvent = self.List[EventName]
		for i,v in Event.Waiting do
			pcall(coroutine.resume,v)
		end
		return ThreadManager:CreateThread(nil,function()

				return Event.Func(Event.Args())
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
function EventObject:Append<T1>(Funcs:T1)
	local NewObject = EventObject._Append(self,Funcs)
	
	return NewObject
end



--@private
function EventObject._WaitUntil<SelfType,T1>(self:SelfType,Event:T1)
	local self:SelfType&DefaultEventObject = self
	
	
	if typeof(Event) == "string" and self.List[Event] then
		local FoundEvent:DefaultEvent = self.List[Event]
		
		
		local Thr = coroutine.running()
		local Found = table.find(FoundEvent.Waiting,Thr)
		if not Found then
			table.insert(FoundEvent.Waiting,Thr)
		end
		coroutine.yield(Thr)
		
		return self
	end
	return self
end

function EventObject:WaitUntil<T1>(Event:T1)
	local NewObject = EventObject._WaitUntil(self,Event)

	return NewObject
end




return EventManager
