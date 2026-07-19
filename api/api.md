# QuBlox API Reference

Complete API documentation for QuBlox.

---

**Information**
> 
> Does not currently support individual measuring or mid-circuit measuring
> 
> This API documentation is currently a work in progress and will be expanded in the future

---

# Types

| Type | Description |
|------|-------------|
| `qubits` | Number of quantum bits (`integer`) |
| `clbits` | Number of classical bits (`integer`) |
| `qubitIndex` | Index of a qubit (`integer`) |
| `control` | Control qubit index (`integer`) |
| `control...number` | Control qubit index (`integer`) |
| `target...number` | Target qubit index (`integer`) |
| `target` | Target qubit index (`integer`) |
| `a` | qubitIndex (`integer`) |
| `b` | qubitIndex (`integer`) |
| `theta` | Rotation angle in radians (`number`) |

---

# Creating a Circuit

## `QuBlox.new(qubits, clbits)`

Creates a new quantum circuit.

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `qubits` | `integer` | Number of quantum bits |
| `clbits` | `integer` | Number of classical bits |

### Example

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuBlox = require(ReplicatedStorage.QuBlox)

local circuit = QuBlox.new(5, 5)
```

---

# Single-Qubit Gates
### Example

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuBlox = require(ReplicatedStorage.QuBlox)

local circuit = QuBlox.new(5, 5)

circuit:i(2)
circuit:h(3)
```
### Parameters

| Parameter | Type |
|-----------|------|
| `qubitIndex` | `integer` |
| `theta` | `number` |

### Gates

## `circuit:i(qubitIndex)`
Applies the Identity gate to a qubit.
## `circuit:h(qubitIndex)`
Applies the Haddamard gate to a qubit.
## `circuit:x(qubitIndex)`
Applies the Pauli-X gate to a qubit.
## `circuit:y(qubitIndex)`
Applies the Pauli-Y gate to a qubit.
## `circuit:z(qubitIndex)`
Applies the Pauli-Z gate to a qubit.
## `circuit:s(qubitIndex)`
Applies a 90 degree phase shift
## `circuit:sdg(qubitIndex)`
Inverse of the s gate
## `circuit:t(qubitIndex)`
Applies a 45 degree phase shift
## `circuit:tdg(qubitIndex)`
Inverse of the t gate
## `circuit:p(qubitIndex, theta)`
Applies a rotation of the phase by theta
## `circuit:rx(qubitIndex, theta)`
Rotation around the X axis
## `circuit:ry(qubitIndex, theta)`
Rotation around the Y axis
## `circuit:rz(qubitIndex, theta)`
Rotation around the Z axis

---

# Multi-qubit Gates
### Example

``` luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuBlox = require(ReplicatedStorage.QuBlox)
local Circuit = QuBlox.Circuit(2, 2)

Circuit:h(1)
Circuit:cnot(1, 2)

```
### Parameters

| Parameter | Type |
|-----------|------|
| `control` | `integer` |
| `control...number` | `integer` |
| `target` | `integer` |
| `a` | `integer` |
| `b` | `integer` |

### Gates

## `circuit:cnot(control, target)`
Applies the Controlled-NOT gate to a qubit.
## `circuit:cz(control, target)`
Applies the Controlled-Z gate to a qubit.
## `circuit:swap(a, b)`
Swaps the two qubits
## `circuit:ccnot(control1, control2, target)`
Applies the Toffoli gate to a qubit.

---

# Getting Results

### Example
``` luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local QuBlox = require(ReplicatedStorage.QuBlox)
local Circuit = QuBlox.Circuit(2, 2)

--- code ---

local results = Circuit:results(1024)
print(results)
```
### Parameters
| Parameter | Type |
|-----------|------|
| `shots` | `integer` |

### Methods
circuit:results(shots)

