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

function module.CreateMatrix(x, y)
	local buf = BufferMatrix.CreateBuffer(x, y)
	return module.new(buf)
end

function module.__mul(a, b)
	local readf64 = buffer.readf64
	local writef64 = buffer.writef64


	if typeof(a) == "number" then

		local result = BufferMatrix.CreateBuffer(b.rows, b.columns)

		local b_buf = b.matrix.buffer
		local res_buf = result.buffer

		local totalElements = b.rows * b.columns
		local index = 0 

		for i = 1, totalElements do

			local real = readf64(b_buf, index)
			local imag = readf64(b_buf, index + 8)

			writef64(res_buf, index, real * a)
			writef64(res_buf, index + 8, imag * a)

			index += 16 
		end

		return module.new(result)
	end

	if typeof(a) == "table" and typeof(b) == "table" then
		local ax, ay = a.rows, a.columns
		local bx, by = b.rows, b.columns

		if ay ~= bx then
			warn("product undefined: columns of A must match rows of B")
			return
		end

		local c = BufferMatrix.CreateBuffer(ax, by)

		local a_buf = a.matrix.buffer
		local b_buf = b.matrix.buffer
		local c_buf = c.buffer

		local a_stride = a.columns * 16
		local b_stride = b.columns * 16

		local c_index = 0 

		for row = 0, ax - 1 do
			local a_row_start = row * a_stride

			for col = 0, by - 1 do
				local realSum = 0
				local imagSum = 0

				local a_index = a_row_start

				local b_index = col * 16

				for k = 1, ay do
					local ar = readf64(a_buf, a_index)
					local ai = readf64(a_buf, a_index + 8)

					local br = readf64(b_buf, b_index)
					local bi = readf64(b_buf, b_index + 8)

					realSum += (ar * br) - (ai * bi)
					imagSum += (ar * bi) + (ai * br)

					a_index += 16 

					b_index += b_stride 
				end

				writef64(c_buf, c_index, realSum)
				writef64(c_buf, c_index + 8, imagSum)
				c_index += 16 
			end
		end

		return module.new(c)
	end

	warn("unrecognized type")
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

function module:CloneMatrix(matrix) 
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
