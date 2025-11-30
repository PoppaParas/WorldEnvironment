-- @ScriptType: Script
local RepStorage = game:GetService("ReplicatedStorage")

local Modules = RepStorage:WaitForChild("Modules")

local SharedSystems = require(Modules:WaitForChild("SharedSystems"))
task.wait()

local Events = SharedSystems.Modules.EventManager
local TestEvent = Events.CreateEvent(function()
		print("Test")
		return "True"
end,function()
	
end)
local NewObj = Events.new({
	Test = TestEvent
})

local Amnt = 0
local NewObj = NewObj:Append(
	{
		Test2 = Events.CreateEvent(function(Arg1:number)
			print(Arg1,"Shots")
		end,function()
			Amnt += 1
			return Amnt
		end)
	}
)
task.spawn(function()
	task.wait(10)
	NewObj:Disconnect("Test2")
end)

print("Test1")
NewObj:WaitUntil("Test2")
print("Completed!")


