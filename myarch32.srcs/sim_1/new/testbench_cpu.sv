`timescale 1ns / 1ps
module testbench_cpu;

reg clock = 0;
reg reset = 0;

registerRAM registerRAM(
    .clock(clock), 
    .write(uut.ramWrite),
    .address(uut.ramAddress),
    .data(uut.ramData) 
);

cpu uut(
    .clock(clock),
    .reset(reset),  
    .ramData(registerRAM.data) 
);

// Wires for debugging:
// wire [31:0] registers [15:0] = uut.registers.read;
// wire currentState = uut.currentState;
// wire [31:0] RAM [100:0] = registerRAM.ram; 

// wire [31:0] RAM_Data = registerRAM.data;
// wire RAM_Write = registerRAM.write;
// wire [31:0] RAM_Address = registerRAM.address;

wire [31:0] IR_OR = uut.instructionReader.OR;

// wire [31:0] IR_ramData = uut.instructionReader.ramData;
// wire IR_ramWrite = uut.instructionReader.ramWrite;
// wire [31:0] IR_ramAddress = uut.instructionReader.ramAddress;
// wire [31:0] EX_ramData = uut.executor.ramData;
// wire EX_ramWrite = uut.executor.ramWrite;
// wire [31:0] EX_ramAddress = uut.executor.ramAddress;

// wire [31:0] CPU_ramData = uut.ramData;
// wire CPU_ramWrite = uut.ramWrite;
// wire [31:0] CPU_ramAddress = uut.ramAddress;

// wire [31:0] REG_write1 = uut.registers.write1;

// wire IR_enabled = uut.instructionReader.enabled;
// wire EX_enabled = uut.executor.enabled;


always #1 clock = ~clock;

task writeInstruction(input [31:0] address, input [31:0] code, input string text);
    $display("Writing 0x%x   %s", code, text);
    
    registerRAM.ram[address/4] = code;
endtask

initial 
begin 

    // This program fills the RAM with a Fibonacci sequence
    writeInstruction(0, 'h11000004, "MOVE V0, 4");
    writeInstruction(4, 'h11010034, "MOVE V1, 52");

    writeInstruction(8, 'h110b0000, "MOVE V11, 0");
    writeInstruction(12, 'h110c0001, "MOVE V12, 1");
    writeInstruction(16, 'h2201b000, "WRITE [V1], V11");
    writeInstruction(20, 'h2201c004, "WRITE [V1+4], V12");

    writeInstruction(24, 'h21021000, "READ V2, [V1]");
    writeInstruction(28, 'h21031004, "READ V3, [V1 + 4]");
    writeInstruction(32, 'h01043200, "ADD V4, V3, V2");
    writeInstruction(36, 'h22014008, "WRITE [V1+8], V4");

    writeInstruction(40, 'h01011000, "ADD V1, V1, V0");
    writeInstruction(44, 'h310ffffb, "JUMP -5");
    
    $display("Resetting");
    #1
    reset = 1; 
    #3.1 
    reset = 0;
    #1.9
    registerRAM.ram[1022] <= 0;

    #1000

    assert (RAM[13] == 0);
    assert (RAM[14] == 1);
    assert (RAM[15] == 1);
    assert (RAM[16] == 2);
    assert (RAM[17] == 3);
    assert (RAM[18] == 5);
    assert (RAM[19] == 8);
    assert (RAM[20] == 13);
    assert (RAM[21] == 21);
    // ...
    assert (RAM[54] == 165580141);

    $finish;

end
endmodule