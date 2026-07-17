local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuBlox = require(ReplicatedStorage.QuBlox)
local Circuit = QuBlox.Circuit(5, 5)

Circuit:h(1)
Circuit:cnot(1, 2)

local results = Circuit:results(100000)

print(results)
