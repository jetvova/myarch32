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

wire [31:0] V1 = uut.registers.read[1];

// Wires for debugging:
// wire [31:0] registers [15:0] = uut.registers.read;
// wire currentState = uut.currentState;
// wire [31:0] RAM [5:0] = registerRAM.ram; 

// wire [31:0] RAM_Data = registerRAM.data;
// wire RAM_Write = registerRAM.write;
// wire [31:0] RAM_Address = registerRAM.address;

// wire [31:0] IR_OR = uut.instructionReader.OR;

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

    writeInstruction(0, 'h11000001, "MOVE V0, 1");
    writeInstruction(4, 'h01011000, "ADD V1, V1, V0");
    writeInstruction(8, 'h310fffff, "JUMP -1");

    $display("Resetting");
    #1
    reset = 1; 
    #3.1 
    reset = 0;
    #1.9
    registerRAM.ram[1022] <= 0;

    #60 

    assert (V1 == 7) else $error("V1 = %d", V1);
    $finish;

end
endmodule