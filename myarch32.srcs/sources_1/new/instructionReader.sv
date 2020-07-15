module instructionReader(
    input clock,
    input [31:0] IR,
    input enabled,
    
    output [3:0] writeAddress1,
    output [31:0] writeData1,
    output write1,

    output ramWrite,
    output [31:0] ramAddress,
    inout [31:0] ramData,

    output reg [31:0] OR

);

assign ramWrite = (enabled == 1) ? 0 : 1'bz;
assign ramAddress = (enabled == 1) ? IR : 32'bz;
assign ramData = 32'bz;

assign writeAddress1 = (enabled == 1) ? 13 : 1'bz;
assign writeData1 = (enabled == 1) ? IR + 4 : 1'bz;
assign write1 = (enabled == 1) ? 1 : 1'bz;


always @(posedge clock) 
begin
    if (enabled) 
    begin
        OR <= ramData;      
    end
end

endmodule
