local module = {}
local QuBlox = script.Parent
local Complex = require(QuBlox.Complex)
local Matrices = require(QuBlox.Matrices)

function module.Vector(x)
	local matrix = {}
	for row = 1, x do
		matrix[row] = {}
		matrix[row][1] = 0
	end

	return Matrices.new(matrix)
end

function module.Qubit(x)
	if x == 0 then
		return Matrices.new({{1},{0}})
	elseif x == 1 then
		return Matrices.new({{0},{1}})
	end
end

function module.StateVector(qubits)
	local qubit = qubits[1]
	
	for i = 2, #qubits do
		qubit = qubit:Tensor(qubits[i])
	end
	
	return qubit
end
return module
