# QuBlox

## What is this?

QuBlox is an open-source quantum computing simulator built for Roblox using Luau.

It provides state vector simulation, quantum gates, measurements, and support for creating custom circuits.

## Where can I download it?

You can find QuBlox on the Roblox Creator Store:

[QuBlox - Roblox Creator Store](https://create.roblox.com/store/asset/128728018797616/QuBlox)

Or in the latest release:

[QuBlox v1.1 - Github](https://github.com/coolguy65161/QuBlox/releases/tag/v1.1)

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

---

# QuBlox v2.0 - Latest Version

## Changes
- Optimized Statevector Calculations
- Added direct amplitude modification
- Added throttling to prevent script exhaustion and frame drops
- Raised qubit limit to >20 qubits
- For qubit amounts under 15, 5000+ gates can be done under a minute
  
## Benchmarks
Example:
- 7-qubit GHZ state
- 500,000 measurements
- ~747 milliseconds

Example:
- 5-qubit GHZ state
- 1,000 measurements
- ~1.1 milliseconds

Example:
- 26-qubit GHZ state (max possible qubits for Roblox)
- 1,000 measurements
- ~102 seconds
## Additional Information
> Roblox took down the original QuBlox v1.0, and other reuploads. For now you will have to download directly from the release page at [Release QuBlox v2.0 · coolguy65161/QuBlox](https://github.com/coolguy65161/QuBlox/releases/tag/v2.0)
