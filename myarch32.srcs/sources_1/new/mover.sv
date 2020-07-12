module mover(
    input [19:0] args,
    input [31:0] readValues[15:0],
    input [3:0] operation,
    output [31:0] result
);

wire[31:0] simpleResult = readValues[args[15:12]];
wire[31:0] immediateResult = args[15:0];
wire[31:0] bigResult = args * 'h10000 | readValues[args[19:16]];

assign result = 
    (operation == 4'b0000)? simpleResult :  // MOVE Vx, Vy
    (operation == 4'b0001)? immediateResult : // MOVE Vx, <16 bit IMMEDIATE>
    (operation == 4'b0010)? bigResult : // BIGMOVE Vx, <16 bit IMMEDIATE>
    -1;

endmodule
