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

function module.Qubit()
	return {}
end

function module.StateVector(qubits)
	local matrix = Matrices.CreateMatrix(2^#qubits, 1)
	matrix:Set(1,1,1,0)
	return matrix
end
return module
