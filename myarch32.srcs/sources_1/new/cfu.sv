module cfu(
    input [19:0] args,
    input [31:0] readValues[15:0],
    input [3:0] operation,
    output [31:0] result
);

wire [31:0] jumpRegisterResult = readValues[args[19:16]];

// Copying the immediate into a 30 bit bus, and duplicating
// the first bit to preserve the sign.
wire [29:0] immediate = { {10{args[19]}}, args[19:0] };

// When the instruction is executed, IR already points to the next
// instruction, meaning we need to subract 4.
wire [31:0] currentAddress = readValues[13] - 4;
// IMMEDIATE refers to how many instructions we want to jump down,
// and as such it needs to be multiplied by their length.
wire [31:0] jumpImmediateResult = currentAddress + immediate * 4;

assign result = 
    (operation == 4'b0000)? jumpRegisterResult :  // JUMP Vx
    (operation == 4'b0001)? jumpImmediateResult : // JUMP <20 bit IMMEDIATE>
    -1;

endmodule
