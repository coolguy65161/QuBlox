local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuBlox = require(ReplicatedStorage.QuBlox)
local Circuit = QuBlox.Circuit(5, 5)

Circuit:h(1)
Circuit:cnot(1, 2)
Circuit:cnot(2, 3)
Circuit:cnot(3, 4)
Circuit:cnot(4, 5)

local results = Circuit:results(100000)

print(results)
