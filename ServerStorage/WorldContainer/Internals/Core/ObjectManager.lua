-- @ScriptType: ModuleScript
local ObjectManager = {}
local Object = {}
Object.__Index = Object



export type Object<T> = T & typeof(Object)
function CreateNewObject<T>():Object<T>
	local Thing:Object<{
		
	}>
	
	
end
function Object:TestFunc()
	return true
end

return ObjectManager
