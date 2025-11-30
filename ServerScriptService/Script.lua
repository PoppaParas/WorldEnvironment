-- @ScriptType: Script
local RepStorage = game:GetService("ReplicatedStorage")

local Modules = RepStorage:WaitForChild("Modules")

local SharedSystems = require(Modules:WaitForChild("SharedSystems"))
task.wait()

print(SharedSystems.Level1.IndexManager.ObjectIndexes)