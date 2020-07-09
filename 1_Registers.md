# Registers

The CPU has 16 special memory regions called registers, labelled in numerical order from V0 to V15. They offer near-instantaneous access to their contents, and act as scratch paper for the computer to do its work on. 

Registers V13, V14, and V15 are reserved for special purposes. They store the location of the instruction being executed, the address to which the control flow would need to return to, and the position of the stack. 

An additional, unique register called FR holds various helpful flags, and cannot be directly written to or moved.

## Structure:

| Name | Alias | Description                  |
|------|-------|------------------------------|
| V0   |       |                              |
| V1   |       |                              |
| V2   |       |                              |
| V3   |       |                              |
| V4   |       |                              |
| V5   |       |                              |
| V6   |       |                              |
| ...  |       |                              |
| V12  |       |                              |
| V13  | IR    | Instruction Pointer Register |
| V14  | RR    | Return Address Register      |
| V15  | SR    | Stack Pointer Register       |
| FR   |       | Flag Register                |
