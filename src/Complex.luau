local ComplexMath = {}
ComplexMath.__index = ComplexMath

function ComplexMath.multiply(ar, ai, br, bi)
	return ar * br - ai * bi, ar * bi + ai * br
end

function ComplexMath.add(ar, ai, br, bi)
	return ar + br, ai + bi
end

function ComplexMath.cmplx(r, i)
	return {r,i}
end
return ComplexMath
