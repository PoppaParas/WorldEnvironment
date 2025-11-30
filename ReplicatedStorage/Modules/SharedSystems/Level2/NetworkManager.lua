-- @ScriptType: ModuleScript
--[[
Novus,omni_novus,11/30/25
Network Manager
Handles all networking
]]

--//Physical Locations

local RepStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Libraries = script.Parent.Parent

local Utils = Libraries:WaitForChild("Utils")

--//Modules
local List = require(Utils:WaitForChild("List"))


--//Constants
local IsServer = RunService:IsServer()

--//Typecasts
export type RemoteObjectType = {
	Object:RemoteEvent|RemoteFunction,
	Name:string,
	Event:RBXScriptConnection?,


}
export type RemoteType = "Event"|"Function"
export type RemoteCreateParameters = {
	RemoteType:RemoteType
}


--//Variables
local RemoteList:List.ListObjectType<string,RemoteObjectType> = List.new()
local NetworkManager = {}


function CorrectParameters(Parameters:RemoteCreateParameters?)
	Parameters = Parameters or {}
	Parameters.RemoteType = Parameters.RemoteType or "Event"
	return Parameters
end

local RemoteAliases = {
	["Function"] = "RemoteFunction",
	["Event"] = "RemoteEvent"
}

function CreateEvent(EventName:string,Parameters:RemoteCreateParameters)
	local New = Instance.new(RemoteAliases[Parameters.RemoteType])
	New.Name = EventName
	New.Parent = script
	return New
end

function GetOrCreateEvent(EventName:string,Parameters:RemoteCreateParameters)
	local Event = RemoteList:Find(EventName)
	if Event then return Event end
	Parameters = CorrectParameters(Parameters)
	local Event = CreateEvent(EventName,Parameters)
	local Obj:RemoteObjectType = {
		Object = Event,
		Name = EventName,
		RemoteType = Parameters.RemoteType
	}
	RemoteList:Set(EventName,Obj)
	return Obj
end

function NetworkManager:CreateServerEvent(EventName:string,Parameters:RemoteCreateParameters,Func:(player,...any)->...any)
	if not IsServer then return end
	Parameters = CorrectParameters(Parameters)
	print(Parameters)
	local Event = GetOrCreateEvent(EventName,Parameters)
	if not Event then return end
	print(Event,Func)
	if Event.Object:IsA("RemoteEvent") then
		if Event.Event then 
			Event.Event:Disconnect()
		end
		local EventOBJ:RemoteEvent = Event.Object
		Event.Event = EventOBJ.OnServerEvent:Connect(Func)
	else
		local EventOBJ:RemoteFunction = Event.Object
		EventOBJ.OnServerInvoke = Func
	end

end
local ClientConnections:{[RemoteEvent]:RBXScriptConnection} = {}
function NetworkManager:CreateClientEvent(EventName:string,Parameters:RemoteCreateParameters,Func:(Player,...any)->...any)

	if IsServer then return end
	Parameters = CorrectParameters(Parameters)

	local FoundOBJ:RemoteFunction|RemoteEvent = script:FindFirstChild(EventName)
	if not FoundOBJ then return end



	if FoundOBJ:IsA("RemoteEvent") then
		local Event = ClientConnections[FoundOBJ]
		if Event then 
			Event:Disconnect()
		end
		ClientConnections[FoundOBJ] = FoundOBJ.OnClientEvent:Connect(Func)
	else
		FoundOBJ.OnClientInvoke = Func
	end

end

function NetworkManager:FireServerEvent(EventName:string,...)
	if IsServer then return end

	local FoundOBJ:RemoteFunction|RemoteEvent = script:FindFirstChild(EventName)
	if not FoundOBJ then return end

	if FoundOBJ:IsA("RemoteEvent") then
		print(...)
		FoundOBJ:FireServer(...)
	elseif FoundOBJ:IsA("RemoteFunction") then
		return FoundOBJ:InvokeServer(...)
	end
end


function NetworkManager:FireClientEvent(EventName:string,PlayerTarg:Player|nil,...)
	if not IsServer then return end
	if not PlayerTarg then
		PlayerTarg = Players:GetPlayers()
	end
	if type(PlayerTarg) ~= "table" then
		PlayerTarg = {PlayerTarg}
	end
	local PlayerTarg:{Player} = PlayerTarg
	local FoundOBJ = RemoteList:Find(EventName)
	if not FoundOBJ then return end
	if FoundOBJ.Object:IsA("RemoteEvent") then
		for i,v in PlayerTarg do
			FoundOBJ.Object:FireClient(v,...)
		end
	elseif FoundOBJ.Object:IsA("RemoteFunction") then
		return FoundOBJ.Object:InvokeClient(PlayerTarg[1],...)
	end
end


return NetworkManager
