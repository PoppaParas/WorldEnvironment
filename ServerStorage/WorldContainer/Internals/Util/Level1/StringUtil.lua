-- @ScriptType: ModuleScript
--[[
paras_cold, 10/21/25
Additional utilities for string types
]]

local StringUtil = {}
setmetatable(StringUtil,{
	__index = string
})
type StringUtilType = typeof(StringUtil)
StringUtil = StringUtil :: StringUtilType

--[[
Takes in a table of strings and returns a string 
with each element concatenated. good for when the string is
unbearably long
]]
function StringUtil:AddStrings(StringTable:{
	string
	})
	assert(type(StringTable) == "table","StringTable must be a table")
	local NewString = ""
	local Index = 1
	repeat
		NewString = `{NewString}{StringTable[Index]}`
		Index += 1
	until Index > #StringTable
	return NewString
end


return StringUtil
