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


assign writeAddress1 = instruction[19:16];
assign writeAddress2 = instruction[7:4];
assign writeData1 = alu.result[31:0];
assign writeData2 = alu.result[63:32];
assign write1 = 1;
// The overflow bits are always calculated, but only written
// if the instruction is a multiply and the output registers
// aren't the same.
assign write2 = (instruction[31:24] == 3) && (writeAddress1 != writeAddress2);

endmodule
