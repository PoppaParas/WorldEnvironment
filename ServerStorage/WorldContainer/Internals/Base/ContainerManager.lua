-- @ScriptType: ModuleScript
-- @ScriptType: ModuleScript


local ContainerManager = {}
local ContainerObject = {}
ContainerObject.__index = ContainerObject

type UpdateFuncType<ValType> = (Property:string,Value:ValType)->any

export type ContainerAccessClass = "Public"|"Private"

export type Container = {
	Class:ContainerAccessClass
} & typeof(setmetatable({},ContainerObject))

function ContainerManager.new():Container
	local self:Container = setmetatable({
		
	},ContainerObject)
	
	self.Containers = {}
	
	return self
	
end

return ContainerManager
