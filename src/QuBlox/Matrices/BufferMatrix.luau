local module = {}
function module.CreateBuffer(row, col)
	local buf = 
		{
			buffer = buffer.create(row * col * 16),
			columns = col,
			rows = row
		}
	return buf
end
function module.Get(buf, row, col)
	local index = ((row - 1) * buf.columns + (col - 1)) * 16

	local real = buffer.readf64(buf.buffer, index)
	local imag = buffer.readf64(buf.buffer, index + 8)

	return real, imag
end
function module.Set(buf, row, col, real, imag)
	local index = ((row - 1) * buf.columns + (col - 1)) * 16
	buffer.writef64(buf.buffer, index, real or 0)
	buffer.writef64(buf.buffer, index + 8, imag or 0)
end
function module.GetStateOpt(buf, row)
	local index = (row - 1) * 16
	local real = buffer.readf64(buf, index)
	local imag = buffer.readf64(buf, index + 8)

	return real, imag
end
function module.SetStateOpt(buf, row, real, imag)
	local index = (row - 1) * 16
	buffer.writef64(buf, index, real)
	buffer.writef64(buf, index + 8, imag)
end
function module.SwapState(buf, a, b)

	local indexA = (a-1)*16
	local indexB = (b-1)*16

	local ar = buffer.readf64(buf,indexA)
	local ai = buffer.readf64(buf,indexA+8)

	local br = buffer.readf64(buf,indexB)
	local bi = buffer.readf64(buf,indexB+8)

	buffer.writef64(buf,indexA,br)
	buffer.writef64(buf,indexA+8,bi)

	buffer.writef64(buf,indexB,ar)
	buffer.writef64(buf,indexB+8,ai)
end
return module
