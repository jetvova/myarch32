module executor(
    input enabled,
    input [31:0] instruction,
    input [31:0] readValues [15:0],
    
    output [3:0] writeAddress1,
    output [3:0] writeAddress2,
    output [31:0] writeData1,
    output [31:0] writeData2,
    output write1,
    output write2,

    output ramWrite,
    output [31:0] ramAddress,
    inout [31:0] ramData
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

memoryAccess memoryAccess (
    .args(instruction[19:0]),
    .readValues(readValues),
    .operation(instruction[27:24]),
    .write(ramWrite),
    .address(ramAddress),
    .data(ramData)
);

wire[3:0] instructionType = instruction[31:28];
assign memoryAccess.enabled = enabled && instructionType == 2;

assign writeAddress1 = (enabled == 1 && instructionType == 3)? 13 :
                       (enabled == 1 && instructionType != 3)? instruction[19:16] :
                       4'bz;

// The value to be written to registers is selected out of many
// possible options using the group number of the instruction.
assign writeData1 = (enabled == 1 && instructionType == 0)? alu.result[31:0] :
                    (enabled == 1 && instructionType == 1)? mover.result :
                    (enabled == 1 && instructionType == 2)? memoryAccess.result :
                    (enabled == 1 && instructionType == 3)? cfu.newIR :
                    32'bz;
// Do not update any register if the instruction is write.
assign write1 = (enabled == 1 && instruction[31:24] == 'h22)? 0 :
                (enabled == 1 && instruction[31:24] != 'h22)? 1 :
                1'bz;

assign writeAddress2 = (enabled == 1 && instructionType == 0)? instruction[7:4] :
                       (enabled == 1 && instructionType == 3)? 14 :
                       4'bz;

assign writeData2 = (enabled == 1 && instructionType == 0)? alu.result[63:32] :
                    (enabled == 1 && instructionType == 3)? cfu.newRR :
                    32'bz;

assign write2 = ((instruction[31:24] == 'h03) && (writeAddress1 != writeAddress2))? 1 : 
                (instructionType == 3)? 1 :
                1'bz;

endmodule
