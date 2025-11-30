-- @ScriptType: ModuleScript
local TableUtil = {}

local TypeBases = {
	number = "NumberValue",
	boolean = "BoolValue",
	string = "StringValue",
	Vector3 = "Vector3Value",
	Color3 = "Color3Value",
	CFrame = "CFrameValue",
}


function TableUtil:Clone<T>(Table:T):T
	local NewTable = table.clone(Table)
	for i,v in NewTable do
		if type(v) == "table" then
			NewTable[i] = TableUtil:Clone(v)
		end
	end
	return NewTable
end


function TableUtil:Clear<T>(Table:T):{}
	local NewTable = table.clone(Table)
	for i,v in NewTable do
		if type(v) == "table" then
			TableUtil:Clear(v)
		end
	end
	table.clear(Table)
	return NewTable
end

function TableUtil:Overwrite<T1,T2>(Table1:T1,Table2:T2)
	assert(type(Table1) == "table" and type(Table1) == type(Table2), "Table1 or Table2 not a table")

	for i,v:{} in Table2 do
		if type(v) == "table" and type(Table1[i]) == "table" then
			TableUtil:Overwrite(Table1[i],v)
		elseif type(v) == "table" then
			v = TableUtil:Clone(v)
		else

			Table1[i] = v
		end
	end
end

function TableUtil:TableToInstance(Table:{[string]:any}):Folder|ValueBase
	local Folder = Instance.new("Folder")
	for i,v in Table do
		local TypeInst = TypeBases[typeof(v)]
		if type(v) == "table" then
			local NewFolder = TableUtil:TableToInstance(v)
			NewFolder.Name = i
			NewFolder.Parent = Folder

		elseif TypeInst then

			local Val:ValueBase = Instance.new(TypeInst)
			Val.Name = i
			Val.Value = v
			Val.Parent = Folder
		end
	end
	return Folder
end


function TableUtil:InstanceToTable(Inst:Instance):{[string]:any}
	local Tab = {}
	for i,v in Inst:GetChildren() do
		if v:IsA("Folder") then
			Tab[v.Name] = TableUtil:InstanceToTable(v)
			continue
		end
		Tab[v.Name] = v.Value
	end

	return Tab
end

return TableUtil