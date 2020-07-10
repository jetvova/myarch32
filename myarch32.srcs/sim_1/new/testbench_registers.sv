`timescale 10ns / 1ps
module testbench_registers;

reg [3:0] writeAddress1;
reg [3:0] writeAddress2;
reg [31:0] writeData1;
reg [31:0] writeData2;
reg write1;
reg write2;
reg clock = 0;
reg reset = 0;
wire [31:0] read [15:0];
    
registers uut (writeAddress1, writeAddress2, writeData1, writeData2, write1, write2, clock, reset, read);

always #1 clock = ~clock;
    
initial 
begin 
    #1
    $display("Testing Write");
    writeAddress1 = 0;
    writeData1 = 420;
    write1 = 1;
    
    writeAddress2 = 1;
    writeData2 = 69;
    write2 = 1;
    
    #2
    write1 = 0;
    write2 = 0;
    
    
    assert (read[0] == 420) else $error("read[0] = %d", read[0]);
    assert (read[1] == 69) else $error("read[1] = %d", read[1]);
        

    $display("Testing Reset");
    reset = 1;
    #2
    reset = 0;

    for (int i = 0; i < 16; i++) 
    begin
        assert (read[i] == 0) else $error("read[%d] = %d", i, read[i]);
    end    

    #5 $finish;
end

    
endmodule
