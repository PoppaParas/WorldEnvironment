-- @ScriptType: ModuleScript
--!nocheck
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Libraries = script.Parent.Parent

local Level1 = Libraries:WaitForChild("Level1")
local Utils = Libraries:WaitForChild("Utils")


local List = require(Utils:WaitForChild("List"))
local IndexManager = require(Level1:WaitForChild("IndexManager"))
local CurrentAnimators:List.ListObjectType<Instance,AnimatorObjectType> = List.new()

local Anims = IndexManager.ObjectIndexes.Anims

local AnimManager = {
	CurrentAnimators = CurrentAnimators
}

local AnimatorObject = {}
AnimatorObject.__index = AnimatorObject

local AnimObject = {}
AnimObject.__index = AnimObject

local DefaultPlayAnimConfig = {
	Looped = false,
	Speed = 1,
	Weight = 1,
	Priority = Enum.AnimationPriority.Core,
	FadeTime = .2
}

export type AnimatorObjectType = {
	Object:Animator,
	Anims:List.ListObjectType<string,AnimationTrack>
} & typeof(AnimatorObject)

export type AnimConfig = typeof(DefaultPlayAnimConfig)

function FindAnim(Path:{string},Target:Folder) : AnimationTrack?
	if not Path then return Target end
	if not Target then Target = Anims end
	local Thing = Path[1]
	local NewFolder = Target:FindFirstChild(Thing)
	if not NewFolder then return end
	table.remove(Path,1)
	if #Path >= 1 then
		NewFolder = FindAnim(Path,NewFolder)
	end
	return NewFolder

end

function AdjustConfig(Config:AnimConfig?):AnimConfig
	Config = Config or {}
	if not Config then return end
	for i,v in  DefaultPlayAnimConfig do
		Config[i] = Config[i] ~= nil and Config[i] or DefaultPlayAnimConfig[i]
	end
	return Config
end

function StopAnim(Anim:AnimationTrack,FadeTime:number?)
	Anim:Stop(FadeTime)
end

function AnimManager.new(Object:Animator):AnimatorObjectType
	local Animator = CurrentAnimators:Find(Object)
	if Animator then return Animator end
	for i,v:AnimationTrack in Object:GetPlayingAnimationTracks() do
		v:Stop()
	end
	local ObjTable:AnimatorObjectType = {
		Object = Object,
		Anims = List.new(),

	}
	local NewTab:AnimatorObjectType = setmetatable(ObjTable,AnimatorObject)
	CurrentAnimators:Set(Object,NewTab)


	return NewTab


end

function AnimatorObject:StopAnim(Index:string,Config:AnimConfig)
	local self:AnimatorObjectType = self

	Config = AdjustConfig(Config)

	if not Config then return end
	local AnimTrack = self.Anims:Find(Index)
	if AnimTrack then StopAnim(AnimTrack,Config.FadeTime) end
end

function AnimatorObject:PlayAnim(Path:{string},Index:string,Config:AnimConfig) : AnimationTrack?
	local self:AnimatorObjectType = self
	
	Config = AdjustConfig(Config)

	if not Config then return end
	local AnimTrack = self.Anims:Find(Index)
	if AnimTrack then StopAnim(AnimTrack,Config.FadeTime) end
	local Anim = FindAnim(Path)

	if not Anim then return end
	AnimTrack = self.Object:LoadAnimation(Anim)
	AnimTrack.Priority = Config.Priority
	AnimTrack.Looped = Config.Looped
	AnimTrack:Play(Config.FadeTime,Config.Weight,Config.Speed)
	
	--AnimTrack.Priority = Config.Priority

	--[[
	repeat
		
		
		AnimTrack:Play(Config.FadeTime,Config.Weight,Config.Speed)
		task.wait()
	until AnimTrack.IsPlaying --and AnimTrack.Looped
	]]
--print(self.Object:GetPlayingAnimationTracks())
	--AnimTrack.Looped = Config.Looped
	self.Anims:Set(Index,AnimTrack)
	return AnimTrack
end

return AnimManager