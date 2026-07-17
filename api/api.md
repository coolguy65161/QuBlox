# QuBlox API Reference

Complete API documentation for QuBlox.

---

# Types

| Type | Description |
|------|-------------|
| `qubits` | Number of quantum bits (`integer`) |
| `clbits` | Number of classical bits (`integer`) |
| `qubitIndex` | Index of a qubit (`integer`) |
| `control` | Control qubit index (`integer`) |
| `target` | Target qubit index (`integer`) |
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

---

> **Note**
>
> This API documentation is currently a work in progress and will be expanded in the future
