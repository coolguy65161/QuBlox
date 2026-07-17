# QuBlox

## What is this?
An open source quantum computing simulator built for Roblox.

## Where can I download this?
You can find this on the Roblox marketplace at: (No link yet)

## Where can I find the API documentation?
You can find the API documentation in api.md in the /api folder

## Example
This is an example of a GHZ state, you can find other examples in the /examples folder
``` luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuBlox = require(ReplicatedStorage.QuBlox)
local Circuit = QuBlox.Circuit(5, 5)

local t = tick()
Circuit:h(1)
Circuit:cnot(1, 2)
Circuit:cnot(2, 3)
Circuit:cnot(3, 4)
Circuit:cnot(4, 5)

local results = Circuit:results(100000)

print(results)
```

## Additional information
> This implementation uses big endian display ordering
> 
> Quantum noise simulation has not been implemented
> 
> Not all gates have been tested
>
> API documentation is still in the works
