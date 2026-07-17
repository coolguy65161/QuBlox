# QuBlox API Reference

Complete API documentation for QuBlox.

## Circuits

### Circuit.new(qubits, clbits)

## Single-Qubit Gates
### :i(qubitIndex)
### :h(qubitIndex)
### :x(qubitIndex)
### :y(qubitIndex)
### :z(qubitIndex)
### :s(qubitIndex)
### :sdg(qubitIndex)
### :t(qubitIndex)
### :tdg(qubitIndex)

## Phase Gates
### :p(index, theta)
### :rx(index, theta)
### :ry(index, theta)
### :rz(index, theta)

## Two-Qubit Gates
### :cnot(control, target)
### :cz(control, target)

## Multi-Qubit Gates
### :ccnot(control1, control2, target)
