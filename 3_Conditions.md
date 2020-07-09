# Conditions

Every instruction is conditional, and can have a trigger created for it by specifying the condition in parentheses. If the corresponding flags within FR are raised, then the instruction will be executed. If not, the CPU just skips it.

(=)

(!=)

(s>)

(s>=)

(s<)

(s<=)

(u>)

(u>=)

(u<)

(u<=)

## Example:

  ```
  JUMP(=) Va   # Jump if equal
  ```
