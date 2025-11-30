-- @ScriptType: ModuleScript
-- @ScriptType: ModuleScript
local ClassManager = {}

local ClassTemplate = {}
ClassTemplate.__index = ClassTemplate

--The class object
local NewClass = {}
NewClass.__index = NewClass

--The current typelisting table for any class
local ClassList = {}


--Class manager methods

--[[
Create new class object
]]
function ClassManager:CreateTemplate<T,TemplateType>(NewInstance:T,Template:TemplateType)
	
end

-- Class template methods



return ClassManager
