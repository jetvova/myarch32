module executor(
    input [31:0] instruction,
    input [31:0] readValues [15:0],
    
    output [3:0] writeAddress1,
    output [3:0] writeAddress2,
    output [31:0] writeData1,
    output [31:0] writeData2,
    output write1,
    output write2

);
    
alu alu (
    .arg1(readValues[instruction[15:12]]),
    .arg2(readValues[instruction[11:8]]),
    .operation(instruction[27:24])
);

mover mover (
    .args(instruction[19:0]),
    .operation(instruction[27:24]),
    .readValues(readValues)
);

cfu cfu (
    .args(instruction[19:0]),
    .operation(instruction[27:24]),
    .readValues(readValues)
);

wire[3:0] instructionType = instruction[31:28];

assign writeAddress1 = (instructionType == 3)? 13 :
                       instruction[19:16];

// The value to be written to registers is selected out of many
// possible options using the group number of the instruction.
assign writeData1 = (instructionType == 0)? alu.result[31:0] :
                    (instructionType == 1)? mover.result[31:0] : 
                    (instructionType == 3)? cfu.newIR[31:0] : 
                    -1;
assign write1 = 1;

assign writeAddress2 = (instructionType == 0)? instruction[7:4] :
                       (instructionType == 3)? 14 :
                       -1;

assign writeData2 = (instructionType == 0)? alu.result[63:32] :
                    (instructionType == 3)? cfu.newRR :
                    -1;

assign write2 = ((instruction[31:24] == 'h03) && (writeAddress1 != writeAddress2)) ||
                (instructionType == 3);

endmodule
