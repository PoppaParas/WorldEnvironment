-- @ScriptType: Script
local RepStorage = game:GetService("ReplicatedStorage")

local Modules = RepStorage:WaitForChild("Modules")

local SharedSystems = require(Modules:WaitForChild("SharedSystems"))
print(SharedSystems.Level1.IndexManager)