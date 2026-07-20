local module = {}
	module.Throttling = true
	--Throttling for amount less than 1e6 (1 million) can cause 2x less performance!
	-- For >50 fps its recommended to turn on throttling but keep iterations below 5e6
	module.Throttling_Iterations = 4e6
return module
