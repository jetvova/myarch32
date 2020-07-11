`timescale 10ns / 1ps
module testbench_executor;
    
reg clock = 0;
reg reset = 0;

reg [31:0] instruction;
reg execEnabled = 0;

reg [3:0] writeAddress1;
reg [3:0] writeAddress2;
reg [31:0] writeData1;
reg [31:0] writeData2;
reg write1;
reg write2;

registers registers (
    .writeAddress1 (execEnabled ? uut.writeAddress1 : writeAddress1),
    .writeAddress2 (execEnabled ? uut.writeAddress2 : writeAddress2),
    .writeData1 (execEnabled ? uut.writeData1 : writeData1),
    .writeData2 (execEnabled ? uut.writeData2 : writeData2),
    .write1 (execEnabled ? uut.write1 : write1),
    .write2 (execEnabled ? uut.write2 : write2),
    .clock (clock),
    .reset (reset)
);

executor uut (
    .instruction (instruction),
    .readValues (registers.read)
);

always #1 clock = ~clock;


wire [31:0] V2 = registers.read[2]; 
wire [31:0] V3 = registers.read[3]; 
wire [31:0] V5 = registers.read[5]; 


initial 
begin 

    $display("Resetting");
    #1
    reset = 1; 
    #2 
    reset = 0;
    #2
    writeAddress1 = 3;
    writeAddress2 = 5;
    writeData1 = 100;
    writeData2 = 25;
    write1 = 1;
    write2 = 1;
    #2
    writeAddress1 = 0;
    writeAddress2 = 0;
    writeData1 = 0;
    writeData2 = 0;
    write1 = 0;
    write2 = 0;
    
    $display("Testing add");
    
    instruction = 'h01023500; // ADD V2, V3, V5
    execEnabled = 1; 
    #2
    instruction = 0;
    execEnabled = 0;

    assert (registers.read[2] == 125) else $error("registers.read[2] = %d", registers.read[2]);
    
    $display("Testing consuming add");
    
    instruction = 'h01033500; // ADD V3, V3, V5
    execEnabled = 1; 
    #2
    instruction = 0;
    execEnabled = 0;

    assert (registers.read[3] == 125) else $error("registers.read[3] = %d", registers.read[3]);


    #5 $finish;
end


endmodule
