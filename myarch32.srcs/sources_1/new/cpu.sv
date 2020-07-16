module cpu (
    input clock,

    input reset,

    output ramWrite,
    output [31:0] ramAddress,
    inout [31:0] ramData
    
);

enum { READING_INSTRUCTION = 0, EXECUTING = 1 } State;

reg currentState = READING_INSTRUCTION;

wire executorEnabled;
assign executorEnabled = (currentState == EXECUTING);

wire readerEnabled;
assign readerEnabled = (currentState == READING_INSTRUCTION);

executor executor (
    .enabled(executorEnabled),
    .instruction(instructionReader.OR),
    .readValues(registers.read)
    //.ramData(data)
);

instructionReader instructionReader (
    .enabled(readerEnabled),
    .clock(clock),
    .IR(registers.read[13])
    //.ramData(data)
);

registers registers (
    .writeAddress2(executor.writeAddress2),
    .writeData2(executor.writeData2),
    .write2(executor.write2),
    .clock(clock),
    .reset(reset)
);

assign registers.writeData1 = executor.writeData1; 
assign registers.writeData1 = instructionReader.writeData1;
assign registers.writeAddress1 = executor.writeAddress1; 
assign registers.writeAddress1 = instructionReader.writeAddress1;
assign registers.write1 = executor.write1; 
assign registers.write1 = instructionReader.write1;

assign registers.writeData2 = executor.writeData2; 
assign registers.writeAddress2 = executor.writeAddress2; 
assign registers.write2 = executor.write2; 
assign ramWrite = instructionReader.ramWrite;
assign ramAddress = instructionReader.ramAddress;

assign executor.ramData = ramData; 
assign instructionReader.ramData = ramData; 
// TODO: Figure out why this doen't work instead:
// assign ramData = executor.ramData; 
// assign ramData = instructionReader.ramData; 

always @(negedge clock) 
begin
    if (reset)
        begin
            currentState <= READING_INSTRUCTION;
        end
    else
        begin
            currentState <= ~currentState; 
        end
end
endmodule
