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
assign writeAddress2 = 0;   //instruction[7:4]
assign writeData1 = alu.result[31:0];
assign writeData2 = 0;  //aluResult[63:32]
assign write1 = 1;
assign write2 = 0;  //If command is multiply

endmodule
