# Encoding

Each CPU instruction is exactly 32 bits (4 bytes) long, and all values are in Big-endian form. All instructions are made up of the following components:

```
| Instruction | Condition | Reserved Bit | Arguments                |
|-------------|-----------|--------------|--------------------------|
| 0000 0000   | 000       | 0            | 0000 0000 0000 0000 0000 |
```

## Instruction Table:

```
| Instruction                | Hex Code     | Binary Code                               | 
|----------------------------|--------------|-------------------------------------------|
| ADD(?) Vx, Vy, Vz          | 0x01(?)xyz00 | 0000 0001 (???0) xxxx yyyy zzzz 0000 0000 |
| SUBTRACT(?) Vx, Vy, Vz     | 0x02(?)xyz00 | 0000 0010 (???0) xxxx yyyy zzzz 0000 0000 |
| MULTIPLY(?) Vx, Vy, Vz, Vw | 0x03(?)xyzw0 | 0000 0011 (???0) xxxx yyyy zzzz wwww 0000 |
| DIVIDE(?) Vx, Vy, Vz       | 0x04(?)xyz00 | 0000 0100 (???0) xxxx yyyy zzzz 0000 0000 |
| COMPARE(?) Vx, Vy          | 0x05(?)xy000 | 0000 0101 (???0) xxxx yyyy 0000 0000 0000 |
| COMPARE(?) Vx, #           | 0x06(?)x#### | 0000 0101 (???0) xxxx #### #### #### #### |
| AND(?) Vx, Vy, Vz          | 0x07(?)xyz00 | 0000 0001 (???0) xxxx yyyy zzzz 0000 0000 |
| OR(?) Vx, Vy, Vz           | 0x08(?)xyz00 | 0000 0001 (???0) xxxx yyyy zzzz 0000 0000 |
| XOR(?) Vx, Vy, Vz          | 0x09(?)xyz00 | 0000 0001 (???0) xxxx yyyy zzzz 0000 0000 |
| NOT(?) Vx, Vy              | 0x0A(?)xy000 | 0000 0001 (???0) xxxx yyyy 0000 0000 0000 |
| SHIFT(?) Vx, Vy, (?), #    | 0x0B(?)xy### | 0000 0001 (???0) xxxx yyyy ??00 #### #### |
| SHIFT(?) Vx, Vy, (?), Vz   | 0x0C(?)xy### | 0000 0001 (???0) xxxx yyyy ??00 zzzz 0000 |
| MOVE(?) Vx, Vy             | 0x10(?)xy000 | 0000 0000 (???0) xxxx yyyy 0000 0000 0000 |
| MOVE(?) Vx, #              | 0x11(?)x#### | 0000 0000 (???0) xxxx #### #### #### #### |
| BIGMOVE(?) Vx, #           | 0x12(?)x#### | 0000 0000 (???0) xxxx #### #### #### #### |
| READ(?) Vx, [Vy]           | 0x20(?)xy000 | 0000 0000 (???0) xxxx yyyy 0000 0000 0000 |
| READ(?) Vx, [Vy + #]       | 0x21(?)xy### | 0000 0000 (???0) xxxx yyyy #### #### #### |
| WRITE(?) [Vx], Vy          | 0x22(?)xy### | 0000 0000 (???0) xxxx yyyy #### #### #### |
| JUMP(?) Vx                 | 0x30(?)x0000 | 0000 0000 (???0) xxxx 0000 0000 0000 0000 |
| JUMP(?) #                  | 0x31(?)##### | 0000 0000 (???0) #### #### #### #### #### |
| CALL(?) Vx                 | 0x32(?)x0000 | 0000 0000 (???0) xxxx 0000 0000 0000 0000 |
| CALL(?) #                  | 0x33(?)##### | 0000 0000 (???0) #### #### #### #### #### |
```
