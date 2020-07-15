module registerRAM(
    input clock,
    input write,
    input [31:0] address,
    inout [31:0] data
);


reg [31:0] ram [1023:0];

assign data = (write == 0)? ram[address[31:2]] : 32'bz;

always @(negedge clock) 
begin
    if (write == 1) 
    begin
        ram[address[31:3]] <= data;
    end
end

endmodule
