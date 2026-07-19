--[[
A lot of this code was made late at night so comments were made after
creating the functions, so some might not make sense

big endian display order

created by coolguy65161
]]

local module = {}
module.__index = module

local Matrices = require(script.Matrices)
local Vectors = require(script.Vectors)
local Gates = require(script.Gates)
local Complex = require(script.Complex)
local BufferMatrix = require(script.Matrices.BufferMatrix)

function module.new()
	local circuit = {}
	setmetatable(circuit, module)
	
	circuit.qubits = {} --remove this later!!! not optimal
	circuit.clbits = {}
	circuit.gates = {}
	circuit.state = {}
	return circuit
end

function module.Circuit(qubits, clbits)
	local circuit = module.new()
	
	for i = 1, qubits do
		table.insert(circuit.qubits, Vectors.Qubit(0)) --removethislaterrememberpls
	end
	for i = 1, clbits do
		table.insert(circuit.clbits, '0')
	end
	
	
	circuit.state = Vectors.StateVector(circuit.qubits)
	

	return circuit
end

------ TENSOR & CIRCUIT CALC ------

local function CloneMatrix(matrix) --im not sure if this is entirely optimal, i will look into it in the future
	local new = BufferMatrix.CreateBuffer(matrix.rows, matrix.columns)

	buffer.copy(
		new.buffer, --target buffer to copy
		0,
		matrix.matrix.buffer, --buffer to take data from
		0,
		buffer.len(matrix.matrix.buffer) --the length of the buffer / bytes to copy
	)

	return Matrices.new(new)
end

function module:results(shots)
	local t = tick()
	self:run() -- update state vector
	print('Time to update the state vector:', tick() - t)
	local probCache = self:CacheStateProbabilites()

	local chanceTable = {} --like qiskit outputs the bit string and how many shots
	
	for i = 1, shots do
		self:ResetClassicalBits()

		--resets the state to the old state vector so it can do the same thing
		--without caching the whole matrix
		
		local bitstring = self:CacheMeasure(probCache)
		chanceTable[bitstring] = (chanceTable[bitstring] or 0) + 1
	end

	return chanceTable

	--this old code is unoptimized but i might need it in the future
	
	--[[local oldStateVector = CloneMatrix(self.state)
	local qubits = #self.qubits

	local chanceTable = {} --like qiskit outputs the bit string and how many shots
	for i = 1, shots do
		self:ResetClassicalBits()
		
		--resets the state to the old state vector so it can do the same thing
		--without caching the whole matrix
		self.state = CloneMatrix(oldStateVector) 
		
		local bitstring = ''
		for i = 1, qubits do
			self:measure(i, i) --measures and outputs to output bit with same index
			local bit = self:ReadClassicalBits(i)
	
			bitstring = bitstring .. bit --makes big endian display order
		end
		chanceTable[bitstring] = (chanceTable[bitstring] or 0) + 1
	end
	return chanceTable--]]
end

local function NumberToBits(number, qubits)
	local bits = {}

	for i = qubits, 1, -1 do
		local bit = math.floor(number / 2^(i-1)) % 2
		table.insert(bits, bit)
	end

	return bits
end

function module:CacheMeasure(cache)
	local qubits = #self.qubits
	local probabilities = cache or self:CacheStateProbabilites()

	local random = math.random()

	for _, prob in ipairs(probabilities) do
		if random < prob[2] then
			return table.concat(
				NumberToBits(prob[1]-1, qubits),
				''
			)
		end
	end

	-- floating point fallback
	local last = probabilities[#probabilities]
	return table.concat(
		NumberToBits(last[1]-1, qubits),
		''
	)
end
function module:CacheStateProbabilites()
	local epsilon = 1e-10

	local qubit = #self.qubits
	local probabilities = {}
	local total = 0

	--calculate total probability
	for i = 1, 2^qubit do
		local real, imag = self.state:Get(i, 1)
		local prob = real^2 + imag^2

		if prob >= epsilon then
			table.insert(probabilities, {i, prob})
			total += prob
		end
	end

	local cumulative = 0
	local array = {}

	for _, entry in probabilities do
		cumulative += entry[2] / total
		table.insert(array, {entry[1], cumulative})
	end

	array[#array][2] = 1 -- remove floating point error

	return array
end


--- OPERATIONS ------


--thanks for this code as well
function module:applySingleQubit(gate, qubit)
	local size = self.state.matrix.rows

	local step = 2^(qubit-1)

	local g11r, g11i = gate:Get(1,1)
	local g12r, g12i = gate:Get(1,2)
	local g21r, g21i = gate:Get(2,1)
	local g22r, g22i = gate:Get(2,2)

	for i = 0, size-1, step*2 do
		for j = 0, step-1 do

			local index1 = i+j+1
			local index2 = index1+step

			local ar, ai = self.state:Get(index1, 1)
			local br, bi = self.state:Get(index2, 1)

			-- g11*a
			local a1r, a1i = Complex.multiply(g11r, g11i, ar, ai)
			-- g12*b
			local b1r, b1i = Complex.multiply(g12r, g12i, br, bi)

			-- g21*a
			local a2r, a2i = Complex.multiply(g21r, g21i, ar, ai)
			-- g22*b
			local b2r, b2i = Complex.multiply(g22r, g22i, br, bi)

			self.state:Set(
				index1,
				1,
				a1r + b1r,
				a1i + b1i
			)

			self.state:Set(
				index2,
				1,
				a2r + b2r,
				a2i + b2i
			)
		end
	end
end
--i stole this off the internet
local function getIndex(base, qubits, localIndex)

	local index = base

	for i = 1, #qubits do

		local bit = bit32.band(
			localIndex,
			2^(i-1)
		)

		if bit ~= 0 then
			index = bit32.bor(
				index,
				2^(qubits[i]-1)
			)
		else
			index = bit32.band(
				index,
				bit32.bnot(2^(qubits[i]-1))
			)
		end
	end

	return index + 1
end
--thx ai lol
function module:applyMultiQubit(gate, qubits)
	local stateSize = self.state.matrix.rows
	local gateSize = gate.rows -- 4, 8, 16, etc.

	local orderedQubits = {}
	for i = #qubits, 1, -1 do
		table.insert(orderedQubits, qubits[i])
	end

	local mask = 0
	for _, q in ipairs(orderedQubits) do

		mask = bit32.bor(mask, bit32.lshift(1, q - 1))
	end

	-- temporary storage
	local input = {}
	local output = {}

	for i = 0, stateSize-1 do

		if bit32.band(i, mask) == 0 then

			local baseIndex = i + 1

			-- Get affected amplitudes
			for j = 0, gateSize-1 do

				-- Note we pass orderedQubits here instead of qubits
				local stateIndex = getIndex(
					baseIndex-1,
					orderedQubits,
					j
				)

				local r, im = self.state:Get(stateIndex, 1)

				input[j] = {
					r,
					im
				}
			end

			-- Matrix multiply gate * vector
			for row = 1, gateSize do
				local realSum = 0
				local imagSum = 0

				for col = 1, gateSize do
					local gr, gi = gate:Get(row,col)

					local ar = input[col-1][1]
					local ai = input[col-1][2]

					local mr, mi = Complex.multiply(
						gr,
						gi,
						ar,
						ai
					)

					realSum += mr
					imagSum += mi
				end
				output[row] = {
					realSum,
					imagSum
				}
			end

			-- Write results back
			for j = 0, gateSize-1 do

				-- Again, use orderedQubits
				local stateIndex = getIndex(
					baseIndex-1,
					orderedQubits,
					j
				)

				self.state:Set(
					stateIndex,
					1,
					output[j+1][1],
					output[j+1][2]
				)
			end

		end -- end bitmask check
	end
end


------ STATE VECTOR CALCULATIONS ------
function module:UpdateStateVector()
	
	for _, operation in ipairs(self.gates) do

		local matrix = operation.matrix
		local indices = operation.indices

		if #indices == 1 then

			self:applySingleQubit(
				matrix,
				indices[1]
			)

		else

			self:applyMultiQubit(
				matrix,
				indices
			)

		end
	end
	self.gates = {}
end

function module:run() --simpler name
	self:UpdateStateVector()
end

------ GATE FUNCTION ------
function module:gate(gate, indices, params) --makes it easier to edit table structure
	local gateTable = {
		indices = indices,	
		matrix = Gates[gate](table.unpack(params or {})),
		gateName = gate
	}
	return gateTable
end
------ GATES ------
function module:i(index)
	local gateTable = self:gate('I', {index})
	table.insert(self.gates, gateTable)
end

function module:h(index)
	local gateTable = self:gate('H', {index})
	table.insert(self.gates, gateTable)
end

function module:x(index)
	local gateTable = self:gate('X', {index})
	table.insert(self.gates, gateTable)
end

function module:y(index)
	local gateTable = self:gate('Y', {index})
	table.insert(self.gates, gateTable)
end

function module:z(index)
	local gateTable = self:gate('Z', {index})
	table.insert(self.gates, gateTable)
end

function module:s(index)
	local gateTable = self:gate('S', {index})
	table.insert(self.gates, gateTable)
end

function module:sdg(index)
	local gateTable = self:gate('Sdg', {index})
	table.insert(self.gates, gateTable)
end

function module:t(index)
	local gateTable = self:gate('T', {index})
	table.insert(self.gates, gateTable)
end

function module:tdg(index)
	local gateTable = self:gate('Tdg', {index})
	table.insert(self.gates, gateTable)
end

function module:cnot(control, target)
	local gateTable = self:gate('CNOT', {control, target})
	table.insert(self.gates, gateTable)
end

function module:cz(control, target)
	local gateTable = self:gate('CZ', {control, target})
	table.insert(self.gates, gateTable)
end

function module:swap(a, b)
	local gateTable = self:gate('SWAP', {a, b})
	table.insert(self.gates, gateTable)
end

function module:ccnot(control1, control2, target)
	local gateTable = self:gate('CCNOT', {control1, control2, target})
	table.insert(self.gates, gateTable)
end

function module:p(index, theta)
	local gateTable = self:gate('P', {index}, {theta})
	table.insert(self.gates, gateTable)
end

function module:rx(index, theta)
	local gateTable = self:gate('RX', {index}, {theta})
	table.insert(self.gates, gateTable)
end

function module:ry(index, theta)
	local gateTable = self:gate('RY', {index}, {theta})
	table.insert(self.gates, gateTable)
end

function module:rz(index, theta)
	local gateTable = self:gate('RZ', {index}, {theta})
	table.insert(self.gates, gateTable)
end
-- for multiple gate matrices

function module:returnI(index) --im not sure what i used this for but i needed it
	local qubit = self.qubits[index]

	local gateTable = {
		indices = {index},	
		matrix = Gates.I().matrix,
		gateName = 'I'
	}
	
	return gateTable
end
------ MEASURE ------
--im not entirely sure what i was doing this and it works but i will try hard to explain
function module:measure(qubitIndex, clbitIndex)

	local amplitudes = self.state
	local qubitCount = #self.qubits

	local probabilities = { --initializes probabilities
		[0] = 0,
		[1] = 0
	}

	-- calculate probabilities
	for i = 1, amplitudes.rows do
		local stateIndex = i - 1 --actual index of the state

		local bit = math.floor( --gets the bit associated with the index? bitstring? idk
			stateIndex / 2^(qubitCount - qubitIndex)
		) % 2

		local real, imag = amplitudes:Get(i, 1) --gets the real and imaginary part from the statevector

		local probability = real^2 + imag^2 

		if bit == 0 then
			probabilities[0] += probability
		else
			probabilities[1] += probability
		end
	end


	-- choose measurement result
	local random = math.random()
	local result

	if random < probabilities[0] then
		result = 0
	else
		result = 1
	end


	-- collapse state
	for i = 1, amplitudes.rows do
		local stateIndex = i - 1 

		local bit = math.floor(
			stateIndex / 2^(qubitCount - qubitIndex)
		) % 2

		if bit ~= result then
			amplitudes:Set(i, 1, 0, 0) --collapses here
		end
	end

	--im not sure what this is for entirely
	local magnitude = 0

	for i = 1, amplitudes.rows do
		local real, imag = amplitudes:Get(i, 1)

		magnitude += real^2 + imag^2
	end


	local normalizer = math.sqrt(magnitude) --getting the distance of real and imag part


	for i = 1, amplitudes.rows do
		local real, imag = amplitudes:Get(i, 1) --

		amplitudes:Set(
			i,
			1,
			real / normalizer, --normalizes the statevector here, not sure why this is needed
			imag / normalizer
		)
	end


	self.clbits[clbitIndex] = tostring(result)

	return result
end

function module:ReadClassicalBits(index)
	return self.clbits[index]
end

function module:ResetClassicalBits()
	self.clbits = table.create(#self.clbits,'0')
end


return module
