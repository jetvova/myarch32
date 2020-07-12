module alu(
    input [31:0] arg1,
    input [31:0] arg2,
    input [3:0] operation,
    output [63:0] result
);
  
wire[31:0] addResult = arg1 + arg2;
wire[31:0] subResult = arg1 - arg2;
wire[63:0] mulResult = arg1 * arg2;

assign result = 
    (operation == 4'b0001)? addResult : 
    (operation == 4'b0010)? subResult :
    (operation == 4'b0011)? mulResult : 
    -1;
         
  
endmodule
