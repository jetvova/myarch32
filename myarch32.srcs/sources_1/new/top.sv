
module top();

wire[31:0] arg1 = 9;
wire[31:0] arg2 = 1;
wire[3:0] operation = 3;
wire[63:0] result;

alu alu1 (
  arg1, arg2, operation, result
  );

//$display(result);

endmodule
