-- @ScriptType: ModuleScript
--[[
	paras_cold
	10/21/25
	FunctionStack:
	Allows you to make a stack of essentially function tables that adds onto
	each other with typecasting, aswell as allows for better function calling
	so you dont need to worry as much about order of declarinbg
	
]]


local Utils = script.Parent.Parent

local Level1Utils = Utils.Level1

local StringUtil = require(Level1Utils.StringUtil)

local FunctionStack = {}
local FunctionObject = {
	__obj = false
}
type FunctionStackType = typeof(FunctionStack)

--[[
Concatenates 2 dictionairies. Extension is added to the original table,
but also overrides original table entries if same index.
]]
@native function Concatenate<T,T2>(Table:T,Extension:T2): T & T2
	for i,v in Extension do
		Table[i] = v
	end
	return Table
end


--[[
Pure registry type function. Needed to be independent to allow
for better autocomplete
]]
function RegisterType<SelfType,T>(self:SelfType,Registry:T) 
	
	local CurrentIndexes = self ~= FunctionStack and self or {}
	type CurrentIndexType = typeof(CurrentIndexes)
	type CombinedRegistryType = SelfType & T & CurrentIndexType
	type RegistryObject = CombinedRegistryType & FunctionStackType
	
	local NewRegistry = Concatenate(Registry,CurrentIndexes)
	
	NewRegistry = setmetatable(NewRegistry,FunctionStack) :: RegistryObject


	return NewRegistry 


end

-- Register Description
--[[
Allows you to initialize a stack object
with ability to chain off :Register functions
for added autocomplete if need be
Arguments:
Registry: The registry to be added to the stack
]]
function FunctionStack:Register<T>(Registry:T) 
	return RegisterType(self,Registry)
end





return FunctionStack