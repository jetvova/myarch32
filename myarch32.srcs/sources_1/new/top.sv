
module top(
    input [3:0] idx,
    output [31:0] value);
    
wire[31:0] arg1 = 9;
wire[31:0] arg2 = 1;
wire[3:0] operation = 3;
wire[63:0] result;

alu alu1 (
  arg1, arg2, operation, result
);

wire [3:0] writeAddress1;
wire [3:0] writeAddress2;
wire [31:0] writeData1;
wire [31:0] writeData2;
wire write1;
wire write2;
wire clock;
wire reset;
wire [31:0] read [15:0];

registers registers1 (writeAddress1, writeAddress2, writeData1, writeData2, write1, write2, clock, reset, read);

assign value = read[idx];

//$display(result);

endmodule
