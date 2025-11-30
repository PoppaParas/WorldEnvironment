-- @ScriptType: ModuleScript
--[[
Novus,omni_novus, 11/30/25
Base
Base non module Base
]]

local Base = {



}


Base.Players            = game.Players
Base.ReplicatedStorage  = game.ReplicatedStorage
Base.ReplicatedFirst    = game.ReplicatedFirst
Base.Lighting           = game.Lighting
Base.HttpService        = game.HttpService
Base.TweenService       = game:GetService("TweenService")
Base.UserInputService   = game:GetService("UserInputService")
Base.RunService         = game:GetService("RunService")
Base.CollectionService  = game:GetService("CollectionService")
Base.ContextActionService = game:GetService("ContextActionService")


Base.Workspace = workspace

local RepStorage = Base.ReplicatedStorage

Base.Assets = RepStorage:WaitForChild("Assets")





return Base
