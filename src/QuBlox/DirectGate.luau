local module = {}
local BufferMatrix = require(script.Parent.Matrices.BufferMatrix)
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
return module
