module top(
    input execEnabled,
    input [3:0] _writeAddress1,
    input [3:0] _writeAddress2,
    input [31:0] _writeData1,
    input [31:0] _writeData2,
    input _write1,
    input _write2,
    input clock,
    input reset,
    input [31:0] instruction,
    output [31:0] result [15:0]
);
    
wire [3:0] writeAddress1;
wire [3:0] writeAddress2;
wire [31:0] writeData1;
wire [31:0] writeData2;
wire write1;
wire write2;
wire [31:0] readValues [15:0];


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

assign result = readValues;


endmodule
