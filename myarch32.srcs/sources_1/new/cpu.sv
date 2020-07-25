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
    .readValues(registers.read),
    .flags(registers.flags)
);

instructionReader instructionReader (
    .enabled(readerEnabled),
    .clock(clock),
    .IR(registers.read[13])
);

registers registers (
    .writeAddress2(executor.writeAddress2),
    .writeData2(executor.writeData2),
    .write2(executor.write2),
    .newFlags(executor.newFlags),
    .writeFlags(executor.writeFlags),
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
assign ramWrite = executor.ramWrite;
assign ramAddress = instructionReader.ramAddress;
assign ramAddress = executor.ramAddress;

assign instructionReader.ramData = ramData; 

assign ramData = (executorEnabled && executor.ramWrite == 1) ? executor.ramData : 32'bz;
assign executor.ramData = (executorEnabled && executor.ramWrite == 0) ? ramData : 32'bz; 

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
