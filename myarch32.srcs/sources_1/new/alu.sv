module alu(
    input [31:0] arg1,
    input [31:0] arg2,
    input [3:0] operation,
    output [63:0] result
    );
  
  wire[63:0] addResult = arg1 + arg2;
  wire[63:0] subResult = arg1 - arg2;
  
  assign result = 
      (operation == 4'b0001)? addResult : 
      (operation == 4'b0010)? subResult : 
      -1;
         
  
endmodule
