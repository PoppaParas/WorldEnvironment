-- @ScriptType: ModuleScript
local RepStorage = game:GetService("ReplicatedStorage")

local Libraries = RepStorage:WaitForChild("Libraries")

local Core = Libraries:WaitForChild("Core")

local List = require(Core:WaitForChild("List"))

local ThreadManager = {}
local ThreadList:List.ListObjectType<string,thread> = List.new()




function ThreadManager:CreateThread<T1,T2>(Index:string?,Func:T1,...:T2):(thread, T2)
	if typeof(Index) ~= "string" and typeof(Index) ~= "nil" then return end
	if typeof(Func) ~= "function" then return end
	local NewThread = ThreadList:Find(Index)
	if NewThread then
		task.cancel(NewThread)
	end
	local NewThread:{thread} & { T2} = {task.spawn(function()
		Func()
	end)}
	if Index then ThreadList:Set(Index,NewThread[1]) end
	return unpack(NewThread)
end

function ThreadManager:StopThread(Index:string)
	if type(Index) ~= "string" then return end
	local Thread = ThreadList:Find(Index)
	if Thread then
		task.cancel(Thread)
	end
end



return ThreadManager