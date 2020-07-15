`timescale 1ns / 1ps
module testbench_instructionReader;

reg clock = 0;
reg reset = 0;

reg [31:0] instruction;
reg iruEnabled = 0;

registers registers (
    .writeAddress1 (uut.writeAddress1),
    .writeData1 (uut.writeData1),
    .write1 (uut.write1),
    .clock (clock),
    .reset (reset)
);

reg write = 0;
reg [31:0] address = 0;
reg [31:0] data; 

registerRAM registerRAM (
    .clock(clock),
    .write(uut.ramWrite),
    .address(uut.ramAddress),
    .data(uut.ramData)
);

instructionReader uut (
    .clock(clock),
    .IR(registers.read[13]),
    .enabled(iruEnabled),
    .ramData(registerRAM.data)
);

wire [31:0] OR = uut.OR;
wire [31:0] IR = registers.read[13]; 
wire [31:0] RAM [1023:0] = registerRAM.ram; 
wire readerRamWrite = uut.ramWrite;
wire [31:0] readerRamData = uut.ramData; 
wire [31:0] readerRamAddress = uut.ramAddress;



always #1 clock = ~clock;

task writeRam(input [31:0] address, input [31:0] value);
    registerRAM.ram[address[31:2]] <= value;
endtask

initial 
begin 

#1
    $display("Resetting registers");
    #1
    reset = 1; 
    #2 
    reset = 0;
    #2
    registers.v[13] <= 1010;

    $display("Filling RAM");
    for (int i=0; i<10; i++) begin
        writeRam(1010 + i*4, 'h12345670 + i);
    end

    for (int i=0; i<10; i++) begin
        iruEnabled = 1;
        #2;
        iruEnabled = 0;
        #0.1;
        assert (OR == 'h12345670 + i) else $error("OR = 0x%x", OR);
        assert (IR == 1014 + i*4) else $error("IR = %d", IR);
        #1.9;
    end

    // #1
    // $display("Testing instructionReader");
    // write = 0;
    // address = 1015;
    // #2
    // assert (data == 'h12345675) else $error("data = 0x%x", data);



    #5 $finish;
end
endmodule
