module alu(
    input [31:0] arg1,
    input [31:0] arg2,
    input [3:0] operation,
    output [63:0] result,
    output [3:0] flags
);
  
wire[32:0] addResult = arg1 + arg2;
wire[32:0] subResult = arg1 - arg2;
wire[63:0] mulResult = arg1 * arg2;
wire[31:0] divResult = arg1 / arg2;

assign result = 
    (operation == 4'b0001)? addResult : 
    (operation == 4'b0010 || operation == 4'b0101 || operation == 4'b0110)? subResult :
    (operation == 4'b0011)? mulResult :
    (operation == 4'b0100)? divResult :
    -1;
         
wire zero = result == 0;
wire carry = result[32];
wire overflow = (result[31] ^ arg1[31]) & (arg1[31] ^ arg2[31] ^ (operation == 4'b0001));
wire sign = result[31] ^ overflow; 

assign flags = {zero, carry, sign, overflow};

endmodule
