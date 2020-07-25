module executor(
    input enabled,
    input [31:0] instruction,
    input [31:0] readValues [15:0],
    input [3:0] flags,

    output [3:0] writeAddress1,
    output [3:0] writeAddress2,
    output [31:0] writeData1,
    output [31:0] writeData2,
    output write1,
    output write2,

    output [3:0] newFlags,
    output writeFlags,

    output ramWrite,
    output [31:0] ramAddress,
    inout [31:0] ramData
);

wire [31:0] aluArg1 = (instruction[31:24] == 'h05 || instruction[31:24] == 'h06)? readValues[instruction[19:16]] :
                      readValues[instruction[15:12]];

wire [31:0] aluArg2 = (instruction[31:24] == 'h05)? readValues[instruction[15:12]] :
                      (instruction[31:24] == 'h06)? instruction[15:0] :
                      readValues[instruction[11:8]];
    
alu alu (
    .arg1(aluArg1),
    .arg2(aluArg2),
    .operation(instruction[27:24])
);

conditionEvaluator conditionEvaluator (
    .condition(instruction[23:20]),
    .flags(flags)
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
wire canExecute = enabled && conditionEvaluator.instructionEnabled;

assign newFlags = alu.flags;
assign writeFlags = canExecute && (instructionType == 0);

assign memoryAccess.enabled = canExecute && instructionType == 2;

assign writeAddress1 = (canExecute && instructionType == 3)? 13 :
                       (canExecute && instructionType != 3)? instruction[19:16] :
                       4'bz;

// The value to be written to registers is selected out of many
// possible options using the group number of the instruction.
assign writeData1 = (canExecute && instructionType == 0)? alu.result[31:0] :
                    (canExecute && instructionType == 1)? mover.result :
                    (canExecute && instructionType == 2)? memoryAccess.result :
                    (canExecute && instructionType == 3)? cfu.newIR :
                    32'bz;
                    
// Do not update any register if the instruction is write or compare.
assign write1 = (canExecute && instruction[31:24] == 'h22)? 0 :
                (canExecute && instruction[31:24] == 'h05)? 0 :
                (canExecute && instruction[31:24] == 'h06)? 0 :
                (canExecute && instruction[31:24] != 'h22 && instruction[31:24] != 'h05 && instruction[31:24] != 'h06)? 1 :
                1'bz;

assign writeAddress2 = (canExecute && instructionType == 0)? instruction[7:4] :
                       (canExecute && instructionType == 3)? 14 :
                       4'bz;

assign writeData2 = (canExecute && instructionType == 0)? alu.result[63:32] :
                    (canExecute && instructionType == 3)? cfu.newRR :
                    32'bz;

assign write2 = (canExecute && (instruction[31:24] == 'h03) && (writeAddress1 != writeAddress2))? 1 : 
                (canExecute && instructionType == 3)? 1 :
                1'bz;

endmodule
