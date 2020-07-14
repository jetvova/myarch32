module memoryAccess (
    input enabled,
    input [19:0] args,
    input [31:0] readValues[15:0],
    input [3:0] operation,
    output [31:0] result,

    output write,
    output [31:0] address,
    inout [31:0] data
);


// Overwrites the upper 16 bits with IMMEDIATE, preserving
// the lower 16 bits of the destination register.
wire [31:0] originalValue = readValues[args[19:16]];
wire [31:0] bigResult = { args[15:0], originalValue[15:0] };

// assign result = 
//    (operation == 4'b0000)? simpleResult :  // MOVE Vx, Vy
//    (operation == 4'b0001)? immediateResult : // MOVE Vx, <16 bit IMMEDIATE>
//    (operation == 4'b0010)? bigResult : // BIGMOVE Vx, <16 bit IMMEDIATE>
//    -1;

assign write = enabled && (operation == 4'b0010);
//assign result = (write == 0)? data : 32'bz;
assign data = readValues[args[15:12]];
assign address = readValues[args[19:16]]; 

endmodule
