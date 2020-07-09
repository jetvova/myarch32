# Instructions

Instructions are the foundation of any program, and are what the CPU reads and executes. To adhere to RISC (Reduced Instruction Set Computer) standards, the instructions have been kept as simple as possible.

## Register Transfer

### `MOVE Va, Vb`
Va = Vb

### `MOVE Va, <IMMEDIATE>`
Va = IMMEDIATE

### `BIGMOVE Va, <IMMEDIATE>`
Load IMMEDIATE into upper half of Va

## Arithmetic/Logical Instructions

### `ADD Va, Vb, Vc`
Va = Vb + Vc

### `SUBTRACT Va, Vb, Vc`
Va = Vb - Vc

### `MULTIPLY Va, Vb, Vc, Vd`
(Va,Vb) = Vc * Vd

If a = b, overflow is discarded

### `DIVIDE Va, Vb, Vc`
Va = Vb / Vc

### `AND Va, Vb, Vc`
Va = Vb & Vc

### `OR Va, Vb, Vc`
Va = Vb | Vc

### `XOR Va, Vb, Vc`
Va = Vb ^ Vc

### `NOT Va, Vb`
Va = ~Vb

### `SHIFT Vx, Vy, (?), <IMMEDIATE>`
Vx = Shift Vy by IMMEDIATE depending on the specific flags.

### `SHIFT Vx, Vy, (?), Vz`
Vx = Shift Vy by Vz depending on the specific flags.

## Control Flow

### `JUMP Va`
IR = Va

### `JUMP <IMMEDIATE>`
IR = IMMEDIATE

### `CALL Va`
RR = IR + 4

IR = Va

### `CALL <IMMEDIATE>`
RR = IR + 4

IR = IMMEDIATE

### `NOP`
No Operation

## Memory Access

### `READ Va, [Vb]`
Va = [Vb]

### `READ Va, [Vb + <IMMEDIATE>]`
Va = [Vb + (0-256)]

### `WRITE [Va], Vb`
[Va] = Vb

### `WRITE [Va + <IMMEDIATE>], Vb`
[Va + (0-256)] = Vb

## Flag Instructions

### `COMPARE Va, Vb`
Compares two registers and sets different flags based on the results

### `COMPARE Va, <IMMEDIATE>`
Compares a register with a IMMEDIATE and sets different flags based on the results
