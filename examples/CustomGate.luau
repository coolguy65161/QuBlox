local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuBlox = require(ReplicatedStorage.QuBlox)
local Gates = require(ReplicatedStorage.QuBlox.Gates)
local Matrices = require(ReplicatedStorage.QuBlox.Matrices)

function Gates.Custom(parameter)
	local array
	if parameter == 1 then
		array = {
			{1, 0},
			{0, 1}
		}
	elseif parameter == 2 then
		array = {
			{0, 1},
			{1, 0}
		}
	end
	
	return Matrices.new(array)
end

function QuBlox:Custom(index, param)
	local gateTable = self:gate('Custom', {index}, {param}) -- 'GateName', {index1, index2, ...}, {param1, param2, ...}
	table.insert(self.gates, gateTable)
end

local Circuit = QuBlox.Circuit(1, 1)

Circuit:Custom(1, 1)

local results = Circuit:results(100000)

print(results)
