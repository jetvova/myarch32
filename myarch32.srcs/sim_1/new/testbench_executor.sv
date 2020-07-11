`timescale 10ns / 1ps
module testbench_executor;
    
wire [3:0] writeAddress1;
wire [3:0] writeAddress2;
wire [31:0] writeData1;
wire [31:0] writeData2;
wire write1;
wire write2;
reg clock = 0;
reg reset = 0;
wire [31:0] readValues [15:0];

reg [31:0] instruction;
reg execEnabled = 0;

reg [3:0] _writeAddress1;
reg [3:0] _writeAddress2;
reg [31:0] _writeData1;
reg [31:0] _writeData2;
reg _write1;
reg _write2;

registers registers1 (
    .writeAddress1 (execEnabled ? writeAddress1 : _writeAddress1),
    .writeAddress2 (execEnabled ? writeAddress2 : _writeAddress2),
    .writeData1 (execEnabled ? writeData1 : _writeData1),
    .writeData2 (execEnabled ? writeData2 : _writeData2),
    .write1 (execEnabled ? write1 : _write1),
    .write2 (execEnabled ? write2 : _write2),
    .clock (clock),
    .reset (reset),
    .read (readValues)
);

executor uut (
    .instruction (instruction),
    .readValues (readValues),
    .writeAddress1 (writeAddress1),
    .writeAddress2 (writeAddress2),
    .writeData1 (writeData1),
    .writeData2 (writeData2),
    .write1 (write1),
    .write2 (write2)
);

always #1 clock = ~clock;


initial 
begin 

    $display("Resetting");
    #1
    reset = 1; 
    #2 
    reset = 0;
    #2
    _writeAddress1 = 3;
    _writeAddress2 = 5;
    _writeData1 = 100;
    _writeData2 = 25;
    _write1 = 1;
    _write2 = 1;
    #2
    _writeAddress1 = 0;
    _writeAddress2 = 0;
    _writeData1 = 0;
    _writeData2 = 0;
    _write1 = 0;
    _write2 = 0;
    
    $display("Testing add");
    
    instruction = 'h01023500; // ADD V2, V3, V5
    execEnabled = 1; 
    #2
    instruction = 0;
    execEnabled = 0;

    assert (readValues[2] == 125) else $error("readValues[2] = %d", readValues[2]);
    
    $display("Testing consuming add");
    
    instruction = 'h01033500; // ADD V3, V3, V5
    execEnabled = 1; 
    #2
    instruction = 0;
    execEnabled = 0;

    assert (readValues[3] == 125) else $error("readValues[3] = %d", readValues[3]);


    #5 $finish;
end


endmodule
