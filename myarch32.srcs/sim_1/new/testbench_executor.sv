`timescale 1ns / 1ps
module testbench_executor;
    
reg clock = 0;
reg reset = 0;

reg [31:0] instruction;
reg execEnabled = 0;

reg [3:0] writeAddress1;
reg [3:0] writeAddress2;
reg [31:0] writeData1;
reg [31:0] writeData2;
reg write1;
reg write2;

registers registers (
    .writeAddress1 (execEnabled ? uut.writeAddress1 : writeAddress1),
    .writeAddress2 (execEnabled ? uut.writeAddress2 : writeAddress2),
    .writeData1 (execEnabled ? uut.writeData1 : writeData1),
    .writeData2 (execEnabled ? uut.writeData2 : writeData2),
    .write1 (execEnabled ? uut.write1 : write1),
    .write2 (execEnabled ? uut.write2 : write2),
    .clock (clock),
    .reset (reset)
);

registerRAM registerRAM (
    .clock (clock),
    .write (uut.ramWrite),
    .address (uut.ramAddress),
    .data (uut.ramData)
);

// Debugging wires for simulation:

wire [3:0] registers_writeAddress1 = registers.writeAddress1;
wire [31:0] registers_writeData1 = registers.writeData1;
wire registers_write1 = registers.write1;
// wire [31:0] mover_result = uut.mover.result;
// wire [15:0] mover_args = uut.mover.args;
// wire [3:0] mover_operation = uut.mover.operation;
wire ramWrite = uut.memoryAccess.write;
wire [31:0] ramAddress = uut.memoryAccess.address;
wire memoryAccessEnabled = uut.memoryAccess.enabled;
wire [31:0] registerRamData = registerRAM.data;

executor uut (
    .instruction (instruction),
    .readValues (registers.read)
);

always #1 clock = ~clock;

wire [31:0] V2 = registers.read[2]; 
wire [31:0] V3 = registers.read[3]; 
wire [31:0] V4 = registers.read[4]; 
wire [31:0] V5 = registers.read[5]; 
wire [31:0] IR = registers.read[13]; 
wire [31:0] RR = registers.read[14];
wire [31:0] RAM [1023:0] = registerRAM.ram;

task writeRegister(input [3:0] target, input [31:0] value);
    writeAddress1 = target;
    writeAddress2 = 0;
    writeData1 = value;
    writeData2 = 0;
    write1 = 1;
    write2 = 0;
    #2
    writeAddress1 = 0;
    writeAddress2 = 0;
    writeData1 = 0;
    writeData2 = 0;
    write1 = 0;
    write2 = 0;
    assert (registers.read[target] == value)
        else $error("Failed to write value= %d to V%d , current value= %d", value, target, registers.read[target]);
endtask

task runInstruction(input [31:0] code, input string text);
    $display("Executing 0x%x   %s", code, text);
    instruction = code;
    execEnabled = 1; 
    #2
    execEnabled = 0;

endtask

initial 
begin 

    $display("Resetting");
    #1
    reset = 1; 
    #2 
    reset = 0;
    #2
    registerRAM.ram[1022] <= 0;

    $display("Testing add");
    writeRegister(4, 100);
    writeRegister(5, 25);
    runInstruction('h01034500, "ADD V3, V4, V5");
    assert (V3 == 125) else $error("V3 = %d", V3);
    
    $display("Testing consuming add");
    writeRegister(4, 100);
    writeRegister(5, 25);
    runInstruction('h01044500, "ADD V4, V4, V5");
    assert (V4 == 125) else $error("V4 = %d", V4);

    $display("Testing multiply");
    writeRegister(4, 100);
    writeRegister(5, 5);
    runInstruction('h03034520, "MULTIPLY V2, V3, V4, V5");
    assert (V2 == 0) else $error("V2 = %d", V2);
    assert (V3 == 500) else $error("V3 = %d", V3);

    $display("Testing overflow multiply");
    writeRegister(4, 'habcd);
    writeRegister(5, 'h1000000);
    runInstruction('h03034520, "MULTIPLY V2, V3, V4, V5");
    assert (V2 == 'hab) else $error("V2 = 0x%x", V2);
    assert (V3 == 'hcd000000) else $error("V3 = 0x%x", V3);
    
    $display("Testing overflow ignore multiply");
    writeRegister(4, 'habcd);
    writeRegister(5, 'h1000000);
    runInstruction('h03034530, "MULTIPLY V3, V3, V4, V5");
    assert (V3 == 'hcd000000) else $error("V3 = 0x%x", V3);

    $display("Testing move");
    writeRegister(3, 2);
    writeRegister(4, 100);
    runInstruction('h10034000, "MOVE V3, V4");
    assert (V3 == 100) else $error("V3 = %d", V3);

    $display("Testing pointless move");
    writeRegister(3, 100);
    runInstruction('h10033000, "MOVE V3, V3");
    assert (V3 == 100) else $error("V3 = %d", V3);

    $display("Testing immediate move");
    writeRegister(3, 2);
    runInstruction('h1103abcd, "MOVE V3, 0xabcd");
    assert (V3 == 'habcd) else $error("V3 = 0x%x", V3);

    $display("Testing big immediate move");
    writeRegister(3, 'h1234);
    runInstruction('h1203abcd, "BIGMOVE V3, 0xabcd");
    assert (V3 == 'habcd1234) else $error("V3 = 0x%x", V3);

    $display("Testing jump");
    writeRegister(3, 100);
    writeRegister(13, 24);
    writeRegister(14, 64);
    runInstruction('h30030000, "JUMP V3");
    assert (IR == 100) else $error("IR = 0x%x", IR);
    assert (RR == 64) else $error("RR = 0x%x", RR);

    $display("Testing immediate jump with positive offset");
    writeRegister(13, 'h24);
    writeRegister(14, 64);
    runInstruction('h31012345, "JUMP +0x12345");
    assert (IR == 'h24 - 4 + 'h12345 * 4) else $error("IR = 0x%x", IR);
    assert (RR == 64) else $error("RR = 0x%x", RR);

    $display("Testing immediate jump with negative offset");
    writeRegister(13, 'h1000004);
    writeRegister(14, 64);
    runInstruction('h310edcbb, "JUMP -0x12345");
    assert (IR == 'h1000004 - 4 - 'h12345 * 4) else $error("IR = 0x%x", IR);
    assert (RR == 64) else $error("RR = 0x%x", RR);

    $display("Testing call");
    writeRegister(3, 100);
    writeRegister(13, 24);
    writeRegister(14, 64);
    runInstruction('h32030000, "CALL V3");
    assert (IR == 100) else $error("IR = 0x%x", IR);
    assert (RR == 24) else $error("RR = 0x%x", RR);
    
    $display("Testing immediate call with positive offset");
    writeRegister(13, 'h24);
    writeRegister(14, 64);
    runInstruction('h33012345, "CALL +0x12345");
    assert (IR == 'h24 - 4 + 'h12345 * 4) else $error("IR = 0x%x", IR);
    assert (RR == 'h24) else $error("RR = 0x%x", RR);

    $display("Testing immediate call with negative offset");
    writeRegister(13, 'h1000004);
    writeRegister(14, 64);
    runInstruction('h330edcbb, "CALL -0x12345");
    assert (IR == 'h1000004 - 4 - 'h12345 * 4) else $error("IR = 0x%x", IR);
    assert (RR == 'h1000004) else $error("RR = 0x%x", RR);

    $display("Testing write");
    writeRegister(3, 1022);
    writeRegister(4, 'h12345678);
    runInstruction('h22034000, "WRITE [V3], V4");
    assert (RAM[1022] == 'h12345678) else $error("RAM[1022] = %d", RAM[1022]);

    $display("Testing offset write");
    writeRegister(3, 1000);
    writeRegister(4, 'h12345679);
    runInstruction('h2203400f, "WRITE [V3 + 0xf], V4");
    assert (RAM[1016] == 'h12345679) else $error("RAM[1016] = %d", RAM[1016]);

    $display("Testing read");
    writeRegister(3, 100);
    writeRegister(4, 1022);
    runInstruction('h21034000, "READ V3, [V4]");
    assert (V3 == 'h12345678) else $error("V3 = %d", V3);

    $display("Testing offset read");
    writeRegister(3, 100);
    writeRegister(4, 1000);
    runInstruction('h2103400f, "READ V3, [V4 + 0xf]");
    assert (V3 == 'h12345679) else $error("V3 = %d", V3);

    #5 $finish;

end
endmodule
