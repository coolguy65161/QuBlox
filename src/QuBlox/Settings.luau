local module = {}
	module.Throttling = true

	-- For >50 fps its recommended to turn on throttling but keep iterations below 3e5 (300,000)
	-- Anything below 1e6 (1,000,000) will cause performance to be 2x slower and will continue to
	-- drop performance significantly below that
	module.Throttling_Iterations = 4e6
return module
