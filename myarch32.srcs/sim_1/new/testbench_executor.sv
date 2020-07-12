`timescale 10ns / 1ps
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

executor uut (
    .instruction (instruction),
    .readValues (registers.read)
);

always #1 clock = ~clock;

wire [31:0] V2 = registers.read[2]; 
wire [31:0] V3 = registers.read[3]; 
wire [31:0] V4 = registers.read[4]; 
wire [31:0] V5 = registers.read[5]; 

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

    #5 $finish;

end

endmodule
