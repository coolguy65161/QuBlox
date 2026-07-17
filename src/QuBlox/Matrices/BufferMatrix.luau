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
return module
