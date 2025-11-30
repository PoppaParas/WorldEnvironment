-- @ScriptType: ModuleScript
--!nocheck
--[[
Novus,omni_novus, 11/30/25
Indexes
Base index config file
]]

local Indexes = {



}

local Base = require(script.Base)



Indexes = setmetatable(Indexes,{
	__index = Base
})  
if true then
	for i,v in Base do
		Indexes[i] = v
	end
end

type Indexes = typeof(Base) & typeof(Indexes)
local Indexes = Indexes :: Indexes


return Indexes
