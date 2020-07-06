# Instructions

## Register Transfer

### `MOVE Va, Vb`
....

### `MOVE Va, <CONSTANT>`
....

## Arithmetic Instructions

### `ADD Va, Vb, Vc`
Va = Vb + Vc

### `SUBTRACT Va, Vb, Vc`
Va = Vb - Vc

### `MULTIPLY Va, Vb, Vc, Vd`
(Va,Vb) = Vc * Vd

If a = b, overflow is discarded

### `DIVIDE Va, Vb, Vc`
Va = Vb / Vc

## Control Flow

### `JUMP Va`
IR = Va

### `JUMP <CONSTANT>`
IR = CONSTANT

### `CALL Va`
RR = IR + 4

IR = Va

### `CALL <CONSTANT>`
RR = IR + 4

IR = CONSTANT

## Memory Access

### `READ Va, [Vb]`
Va = [Vb]

### `READ Va, [Vb + <CONSTANT>]`
Va = [Vb + (0-256)]

### `WRITE [Va], Vb`
[Va] = Vb

### `WRITE [Va + <CONSTANT>], Vb`
[Va + (0-256)] = Vb

## Flag Instructions

### `COMPARE Va, Vb`
Compares two registers and sets different flags based on the results

### `COMPARE Va, <CONSTANT>`
Compares a register with a constant and sets different flags based on the results
