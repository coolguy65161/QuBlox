--!native

local module = {}
local BufferMatrix = require(script.Parent.Matrices.BufferMatrix)

local Settings = require(script.Parent.Settings)
local T = Settings.Throttling
local T_IT = Settings.Throttling_Iterations
local counter = 0 
local function Throttling(add)
	if T then
		counter = counter + add
		if counter >= T_IT then
			counter = 0
			task.wait()
		end
	end
end
------ FUNCTIONS ------
local function GetStateOpt(buf, row)
	local index = (row - 1) * 16
	local real = buffer.readf64(buf, index)
	local imag = buffer.readf64(buf, index + 8)

	return real, imag
end
local function SetStateOpt(buf, row, real, imag)
	local index = (row - 1) * 16
	buffer.writef64(buf, index, real)
	buffer.writef64(buf, index + 8, imag)
end
local function SwapState(buf, a, b)
	local indexA = (a - 1) * 16
	local indexB = (b - 1) * 16

	local ar = buffer.readf64(buf, indexA)
	local ai = buffer.readf64(buf, indexA + 8)

	local br = buffer.readf64(buf, indexB)
	local bi = buffer.readf64(buf, indexB + 8)

	buffer.writef64(buf, indexA, br)
	buffer.writef64(buf, indexA + 8, bi)

	buffer.writef64(buf, indexB, ar)
	buffer.writef64(buf, indexB + 8, ai)
end
local function PhaseFlip(state, row)
	local index = (row - 1) * 16
	buffer.writef64(state, index, -buffer.readf64(state, index))
	buffer.writef64(state, index + 8, -buffer.readf64(state, index + 8))
end

------ SINGLE QUBIT ------
function module:H(indices)
	local qubit = indices[1]
	local size = self.state.matrix.rows
	local buf = self.state.matrix.buffer
	local step = 2^(qubit-1)

	local invSqrt2 = 0.7071067811865476 

	for i = 0, size-1, step*2 do
		Throttling(1) 

		for j = 0, step-1 do
			local index1 = i + j + 1
			local index2 = index1 + step

			local ar, ai = GetStateOpt(buf,index1)
			local br, bi = GetStateOpt(buf,index2)

			SetStateOpt(buf,index1, (ar + br) * invSqrt2, (ai + bi) * invSqrt2)
			SetStateOpt(buf,index2, (ar - br) * invSqrt2, (ai - bi) * invSqrt2)
		end
	end
end
------ MULTI-QUBIT ------
function module:CNOT(indices)

	local control = indices[1]
	local target = indices[2]

	local size = self.state.matrix.rows
	local stateBuffer = self.state.matrix.buffer

	local controlMask = 2^(control-1)
	local targetMask = 2^(target-1)

	for index = 0, size-1 do
		-- control = 1
		-- target = 0
		Throttling(1)
		if bit32.band(index, controlMask) ~= 0
			and bit32.band(index, targetMask) == 0 then


			local swapIndex = bit32.bxor(index, targetMask)


			-- only swap once
			if index < swapIndex then

				SwapState(
					stateBuffer,
					index+1,
					swapIndex+1
				)

			end
		end
	end
end

function module:CCNOT(indices)
	local control1 = indices[1]
	local control2 = indices[2]
	local target = indices[3]

	local size = self.state.matrix.rows
	local qubits = math.log(size) / math.log(2)

	local control1Mask = 2^(control1-1)
	local control2Mask = 2^(control2-1)
	local targetMask = 2^(target-1)


	for index = 0, size-1 do
		Throttling(1)
		-- same for CNOT but checking two
		if bit32.band(index, control1Mask) ~= 0 and bit32.band(index, control2Mask) ~= 0 then
			local swapIndex = bit32.bxor(index, targetMask)
			if index < swapIndex then
				SwapState(
					self.state.matrix.buffer,
					index+1,
					swapIndex+1
				)

			end
		end 
	end
end
function module:CZ(indices)
	local control = indices[1]
	local target = indices[2]

	local size = self.state.matrix.rows
	local buf = self.state.matrix.buffer

	local c_bit = control - 1
	local t_bit = target - 1

	local c_mask = 2^c_bit
	local t_mask = 2^t_bit
	local combined_mask = bit32.bor(c_mask, t_mask)
	local min_bit = math.min(c_bit, t_bit)
	local max_bit = math.max(c_bit, t_bit)

	for i = 0, size - 1, bit32.lshift(1, max_bit + 1) do
		Throttling(1)
		for j = 0, bit32.lshift(1, min_bit) - 1 do

			local base_index = i + j + bit32.bor(c_mask, t_mask)

			PhaseFlip(buf, base_index + 1) 
		end
	end
end

function module:SWAP(indices)
	local q1 = indices[1]
	local q2 = indices[2]
	local size = self.state.matrix.rows
	local buf = self.state.matrix.buffer
	local q1Mask = 2^(q1-1)
	local q2Mask = 2^(q2-1)
	local swapMask = bit32.bor(q1Mask, q2Mask) 

	for index = 0, size-1 do
		Throttling(1)

		if bit32.band(index, swapMask) == q1Mask then
			local targetIndex = bit32.bxor(index, swapMask)
			SwapState(buf, index+1, targetIndex+1)
		end
	end
end
return module
