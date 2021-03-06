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

assign write = (enabled == 0) ? 'bz : (operation == 4'b0010);

assign result = data;

wire [3:0] addressRegister = (operation == 4'b0001)? args[15:12] :
                             (operation == 4'b0010)? args[19:16] :
                             -1;

assign data = (enabled == 0) ? 32'bz :
                (write == 1) ? readValues[args[15:12]] : 
                32'bz;

assign address = (enabled == 0) ? 32'bz :
                 readValues[addressRegister] + args[11:0]; 

endmodule
