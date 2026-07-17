local module = {}
local QuBlox = script.Parent

local Matrices = require(QuBlox.Matrices)
local Vectors = require(QuBlox.Vectors)
local Complex = require(QuBlox.Complex)

------ GATES ------

function module.S()
	local array = {
		{1, 0},
		{0, Complex.cmplx(0,1)}
	}
	return Matrices.new(array)
end

--haddamard
function module.H()
	local array = {
		{1, 1},
		{1, -1}
	}
	local matrix = Matrices.new(array)
	matrix =  1/math.sqrt(2) * matrix

	return matrix
end
--pauli x / not
function module.X()
	local array = {
		{0, 1},
		{1, 0}
	}
	return Matrices.new(array)
end
-- identity matrix
function module.I()
	local array = {
		{1, 0},
		{0, 1}
	}
	return Matrices.new(array)
end
--controlled not
function module.CNOT()
	local array = {
		{1, 0, 0, 0},
		{0, 1, 0, 0},
		{0, 0, 0, 1},
		{0, 0, 1, 0}
	}
	return Matrices.new(array)
end

-- Pauli Y
function module.Y()
	local array = {
		{0, Complex.cmplx(0,-1)},
		{Complex.cmplx(0,1), 0}
	}
	return Matrices.new(array)
end

-- Pauli Z
function module.Z()
	local array = {
		{1, 0},
		{0, -1}
	}
	return Matrices.new(array)
end

-- S dagger (S inverse)
function module.Sdg()
	local array = {
		{1, 0},
		{0, Complex.cmplx(0,-1)}
	}
	return Matrices.new(array)
end

-- T gate
function module.T()
	local angle = math.pi / 4

	local array = {
		{1, 0},
		{0, Complex.cmplx(math.cos(angle), math.sin(angle))}
	}

	return Matrices.new(array)
end

-- T dagger
function module.Tdg()
	local angle = -math.pi / 4

	local array = {
		{1, 0},
		{0, Complex.cmplx(math.cos(angle), math.sin(angle))}
	}

	return Matrices.new(array)
end

-- Controlled Z
function module.CZ()
	local array = {
		{1,0,0,0},
		{0,1,0,0},
		{0,0,1,0},
		{0,0,0,-1}
	}

	return Matrices.new(array)
end

-- SWAP gate
function module.SWAP()
	local array = {
		{1,0,0,0},
		{0,0,1,0},
		{0,1,0,0},
		{0,0,0,1}
	}

	return Matrices.new(array)
end

-- Toffoli / CCNOT
function module.CCNOT()
	local array = {
		{1,0,0,0,0,0,0,0},
		{0,1,0,0,0,0,0,0},
		{0,0,1,0,0,0,0,0},
		{0,0,0,1,0,0,0,0},
		{0,0,0,0,1,0,0,0},
		{0,0,0,0,0,1,0,0},
		{0,0,0,0,0,0,0,1},
		{0,0,0,0,0,0,1,0}
	}

	return Matrices.new(array)
end

-- Phase rotation
function module.P(theta)
	local array = {
		{1,0},
		{0,Complex.cmplx(math.cos(theta), math.sin(theta))}
	}

	return Matrices.new(array)
end

-- Rotation around X axis
function module.RX(theta)
	local c = math.cos(theta/2)
	local s = math.sin(theta/2)

	local array = {
		{c, Complex.cmplx(0,-s)},
		{Complex.cmplx(0,-s), c}
	}

	return Matrices.new(array)
end

-- Rotation around Y axis
function module.RY(theta)
	local c = math.cos(theta/2)
	local s = math.sin(theta/2)

	local array = {
		{c, -s},
		{s, c}
	}

	return Matrices.new(array)
end

-- Rotation around Z axis
function module.RZ(theta)
	local a = Complex.cmplx(
		math.cos(-theta/2),
		math.sin(-theta/2)
	)

	local b = Complex.cmplx(
		math.cos(theta/2),
		math.sin(theta/2)
	)

	local array = {
		{a,0},
		{0,b}
	}

	return Matrices.new(array)
end
return module
