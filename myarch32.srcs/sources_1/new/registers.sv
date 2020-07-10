module registers(
    input [3:0] writeAddress1,
    input [3:0] writeAddress2,
    input [31:0] writeData1,
    input [31:0] writeData2,
    input write1,
    input write2,
    input clock,
    input reset,
    output [31:0] read [15:0]
);
    

reg [31:0] v[15:0];

assign read = v;
    
always @(negedge clock) 
begin
    
    if (reset) 
    begin
        for (int i = 0; i < 16; i++)
        begin
            v[i] <= 0;
        end
    end
    else
    begin
        if (write1)
        begin 
            v[writeAddress1] <= writeData1;
        end

        if (write2)
        begin 
            v[writeAddress2] <= writeData2;
        end
    end
end


endmodule
