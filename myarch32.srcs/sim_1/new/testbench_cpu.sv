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
wire [31:0] registers [15:0] = uut.registers.read;
// wire currentState = uut.currentState;
wire [31:0] RAM [100:0] = registerRAM.ram; 

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

wire DE_enabled = uut.executor.conditionEvaluator.instructionEnabled; 
wire [15:0] ALU_arg1 = uut.executor.alu.arg1; 
wire [3:0] REG_flags = uut.registers.flags;
wire [3:0] EX_newFlags = uut.executor.newFlags;
wire [3:0] ALU_flags = uut.executor.alu.flags;

wire EX_flagsWrite = uut.executor.writeFlags;

always #1 clock = ~clock;

task writeInstruction(input [31:0] address, input [31:0] code, input string text);
    $display("Writing 0x%x   %s", code, text);
    
    registerRAM.ram[address/4] = code;
endtask

initial 
begin 

    // This program fills the RAM with a Fibonacci sequence
    writeInstruction(0, 'h11000004, "MOVE V0, 4");
    writeInstruction(4, 'h1101003c, "MOVE V1, 64");

    writeInstruction(8, 'h110b0000, "MOVE V11, 0");
    writeInstruction(12, 'h110c0001, "MOVE V12, 1");
    writeInstruction(16, 'h2201b000, "WRITE [V1], V11");
    writeInstruction(20, 'h2201c004, "WRITE [V1+4], V12");

    writeInstruction(24, 'h21021000, "READ V2, [V1]"); // <= Jump target
    writeInstruction(28, 'h21031004, "READ V3, [V1 + 4]");
    writeInstruction(32, 'h01043200, "ADD V4, V3, V2");
    writeInstruction(36, 'h22014008, "WRITE [V1+8], V4");

    writeInstruction(40, 'h01011000, "ADD V1, V1, V0");    
    writeInstruction(44, 'h060100b0, "COMPARE V1, 176");

    writeInstruction(48, 'h319ffffa, "JUMP(u<) -6");

    writeInstruction(52, 'h31000000, "JUMP 0");

    registerRAM.ram[46] = 'hffffffff;
    
    $display("Resetting");
    #1
    reset = 1; 
    #3.1 
    reset = 0;
    #1.9

    #950

    assert (RAM[15] == 0);
    assert (RAM[16] == 1);
    assert (RAM[17] == 1);
    assert (RAM[18] == 2);
    assert (RAM[19] == 3);
    assert (RAM[20] == 5);
    assert (RAM[21] == 8);
    assert (RAM[22] == 13);
    assert (RAM[23] == 21);
    // ...
    assert (RAM[45] == 832040);
    assert (RAM[46] == 'hffffffff);

    $finish;

end
endmodule