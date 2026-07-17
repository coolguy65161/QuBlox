local module = {}

local QuBlox = script.Parent
local Complex = require(QuBlox.Complex)
local BufferMatrix = require(script.BufferMatrix)

module.__index = module
--[[
Structure:
[0, 0, 0],
[0, 0, 0],
[0, 0, 0]

All numbers in the array must be passed through into the complex number module
]]
local function Convert(array) --easy to read the code for this one not much explaining
	if array.buffer then
		return array, array.rows, array.columns
	else
		local x = #array
		local y = #array[1]

		local buf = BufferMatrix.CreateBuffer(x, y)

		for row = 1, x do
			for col = 1, y do
				local element = array[row][col]
				if typeof(element) == 'number' then
					-- element is a real number
					BufferMatrix.Set(buf, row, col, element, 0) --why i didnt use the functions i made? i dont know
				elseif typeof(element) == 'table' then
					-- element is a complex number
					BufferMatrix.Set(buf, row, col, element[1], element[2])
				end
			end
		end
		return buf, x, y
	end
end

function module.new(array)
	local convert, x, y = Convert(array)
	return setmetatable({
		matrix = convert,
		rows = x,
		columns = y
	}, module)
end

function module:Size()
	local matrix = self.matrix

	return matrix.rows, matrix.columns
end

--not buffer'd not needed anyway
function module:Column(column) 
	local matrix = self.matrix
	local elements = {}
	for row = 1, #matrix do
		local element = matrix[row][column]
		table.insert(elements,element)
	end
	return elements
end

function module.CreateMatrix(x, y)
	local buf = BufferMatrix.CreateBuffer(x, y)
	return module.new(buf)
end

function module.__mul(a, b)

	if typeof(a) == "number" then --multiplies all rows by the scalar
		local result = module.CreateMatrix(b.rows, b.columns)

		for row = 1, b.rows do
			for col = 1, b.columns do
				local real, imag = b:Get(row, col)

				result:Set(
					row,
					col,
					real * a,
					imag * a
				)
			end
		end

		return result
	end

	if typeof(a) == "table" and typeof(b) == "table" then --two matrices

		local ax, ay = a:Size()
		local bx, by = b:Size()

		if ay ~= bx then
			warn("product undefined: columns of A must match rows of B")
			return
		end

		local c = module.CreateMatrix(ax, by)

		for row = 1, ax do

			for col = 1, by do

				local realSum = 0
				local imagSum = 0

				for k = 1, ay do

					local ar, ai = a:Get(row, k)
					local br, bi = b:Get(k, col)

					local mr, mi = Complex.multiply(ar, ai, br, bi)

					realSum += mr
					imagSum += mi
				end

				c:Set(
					row,
					col,
					realSum,
					imagSum
				)
			end
		end

		return c
	end


	warn("unrecognized type")
end
--not buffer'd
--[[function module:ConjTranspose()
	local matrix = self.matrix
	for row = 1, #matrix do
		for column = 1, #matrix[1] do
			matrix[row][column] = Complex.conj(matrix[row][column])
		end
	end
	
	local new = {}
	for row = 1, #matrix[1] do
		new[row] = {}
		for column = 1, #matrix do
			new[row][column] = matrix[column][row]
		end
	end
	self.matrix = new
end--]]

function module:Tensor(other)

	local selfRows, selfColumns = self:Size()
	local otherRows, otherColumns = other:Size()

	local result = module.CreateMatrix(
		selfRows * otherRows,
		selfColumns * otherColumns
	)

	for i = 1, selfRows do
		for j = 1, selfColumns do

			local scalarReal, scalarImag = self:Get(i, j)

			for k = 1, otherRows do
				local row = (i - 1) * otherRows + k

				for l = 1, otherColumns do
					local col = (j - 1) * otherColumns + l

					local otherReal, otherImag = other:Get(k, l)

					local real, imag = Complex.multiply(
						scalarReal,
						scalarImag,
						otherReal,
						otherImag
					)

					result:Set(
						row,
						col,
						real,
						imag
					)
				end
			end
		end
	end

	return result
end

local function NumberToBits(number, qubits)
	local bits = {}

	for i = qubits, 1, -1 do
		local bit = math.floor(number / 2^(i-1)) % 2
		table.insert(bits, bit)
	end

	return bits
end
local function BitsToNumber(bits)
	local number = 0

	for i = 1,#bits do
		number += bits[i] * 2^(#bits-i)
	end

	return number
end
--not buffer
function module.Identity(size) -- creates identity of any size
	local matrix = {}

	for row = 1, size do
		matrix[row] = {}

		for column = 1, size do
			if row == column then
				matrix[row][column] = 1
			else
				matrix[row][column] = 0
			end
		end
	end

	return module.new(matrix)
end
local function CloneMatrix(matrix) 
	local new = BufferMatrix.CreateBuffer(matrix.rows, matrix.columns)

	buffer.copy(
		new.buffer, 
		0,
		matrix.matrix.buffer, 
		0,
		buffer.len(matrix.matrix.buffer) 
	)

	return module.new(new)
end

function module:ExpandGate(gate, qubitCount) --i know this is necessary, still figuring out the logic behind it

	local size = 2^qubitCount

	local expanded = module.CreateMatrix(size,size)
	
	local indices = table.clone(gate.indices)
	local amount = #indices
	local matrix = CloneMatrix(gate.matrix)
	for inputState = 0, size-1 do

		-- convert number to bits
		local bits = NumberToBits(inputState, qubitCount)


		-- get only the qubits the gate touches
		local smallInput = {}

		for _, index in indices do
			table.insert(
				smallInput,
				bits[index]
			)
		end

		local smallIndex = BitsToNumber(smallInput)

		for outputSmall = 0, 2^(amount)-1 do

			local real, imag = matrix:Get(
				outputSmall + 1,
				smallIndex + 1
			)

			if real ~= 0 or imag ~= 0 then

				local outputBits = table.clone(bits)

				local replacement =
					NumberToBits(
						outputSmall,
						amount
					)

				for i,index in indices do
					outputBits[index] = replacement[i]
				end

				local outputState = BitsToNumber(outputBits)

				expanded:Set(
					outputState + 1,
					inputState + 1,
					real,
					imag
				)
			end
		end
	end

	return expanded
end

------ BUFFERS ------

function module:Get(row, col)
	return BufferMatrix.Get(
		self.matrix, 
		row, 
		col
	)
end
function module:Set(row, col, real, imag)
	return BufferMatrix.Set(
		self.matrix, 
		row, 
		col, 
		real,
		imag
	)
end

return module
