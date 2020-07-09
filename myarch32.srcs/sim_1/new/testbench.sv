`timescale 10ns / 1ps
module testbench;
    
reg [31:0] arg1 = 1;
reg [31:0] arg2 = 5;
reg [3:0] operation = 0;
wire signed [63:0] result;
    
//    alu uut (arg1, arg2, operation, result);

alu uut (
    .arg1 (arg1),
    .arg2 (arg2),
    .operation (operation),
    .result (result)
);
    
integer k = 0;

initial 
begin
    arg1 = 1000;
    arg2 = 500;
    operation = 1;
    #1 assert (result == 1500) else $error("result = %d", result);
        
    arg1 = 1000;
    arg2 = 700;
    operation = 2;
    #1 assert (result == 300) else $error("result = %d", result);
        

    arg1 = 10;
    arg2 = 30;
    operation = 2;
    #1 assert (result == -20) else $error("result = %d", result);
    
    #5 $finish;
end

    
endmodule
