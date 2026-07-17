local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuBlox = require(ReplicatedStorage.QuBlox)
local Gates = require(ReplicatedStorage.QuBlox.Gates)
local Matrices = require(ReplicatedStorage.QuBlox.Matrices)

function Gates.MyGate(parameter)
	local gate
	if parameter == 1 then
		gate = Gates.I()
	elseif parameter == 2 then
		gate = Gates.X()
	end
	
	return gate
end

function QuBlox:MyGate(index, param)
	local gateTable = self:gate('MyGate', {index}, {param}) -- 'GateName', {index1, index2, ...}, {param1, param2, ...}
	table.insert(self.gates, gateTable)
end

local Circuit = QuBlox.Circuit(2, 2)

Circuit:MyGate(1, 1)
Circuit:MyGate(2, 2)

local results = Circuit:results(100000)

print(results)
