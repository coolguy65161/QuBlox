# QuBlox

## What is this?

QuBlox is an open-source quantum computing simulator built for Roblox using Luau.

It provides state vector simulation, quantum gates, measurements, and support for creating custom circuits.

## Where can I download it?

You can find QuBlox on the Roblox Creator Store:

[QuBlox](https://create.roblox.com/store/asset/128728018797616/QuBlox)

## API Documentation

The API documentation can be found here:

`/api/api.md`

## Example

This example creates a 5-qubit GHZ state.

More examples can be found in the `/examples` folder.

```luau
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
```

Expected output:

```
00000 ≈ 50%
11111 ≈ 50%
```

## Features
- State vector simulation
- Complex amplitude support
- Quantum gate system
- Circuit execution
- Measurement sampling
- Custom gate support
- Matrix and tensor operations

## Additional Information

> QuBlox uses big endian display ordering.
>
> Quantum noise simulation has not been implemented.
>
> Not all gates have been fully tested.
>
> API documentation is still being expanded.
