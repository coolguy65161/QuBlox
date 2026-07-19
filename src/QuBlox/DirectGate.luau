local module = {}
function module:CNOT(indices)
	local control = indices[1]
	local target = indices[2]
	local size = self.state.matrix.rows
	local qubits = math.log(size) / math.log(2)

	local controlMask = 2^(control-1)
	local targetMask = 2^(target-1)



	for index = 0, size-1 do

		-- control qubit is 0, ignore
		if bit32.band(index, controlMask) ~= 0 then

			-- flip target bit
			local swapIndex = bit32.bxor(index, targetMask)

			-- only swap once
			if index < swapIndex then

				--ok so it swaps the amplitudes because its not setting the bit its making sure the other one appears instead of other
				local ar, ai = self.state:Get(index+1,1)
				local br, bi = self.state:Get(swapIndex+1,1)

				self.state:Set(
					index+1,
					1,
					br,
					bi
				)

				self.state:Set(
					swapIndex+1,
					1,
					ar,
					ai
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
				local ar, ai = self.state:Get(index+1,1)
				local br, bi = self.state:Get(swapIndex+1,1)

				self.state:Set(
					index+1,
					1,
					br,
					bi
				)

				self.state:Set(
					swapIndex+1,
					1,
					ar,
					ai
				)

			end
		end 
	end
end
return module
