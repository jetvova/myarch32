`timescale 10ns / 1ps
module testbench_registerRAM;

reg clock = 0;
reg write = 0;
reg [31:0] address = 0;
reg [31:0] data; 

registerRAM uut (
    .clock(clock),
    .write(write),
    .address(address),
    .data(dataTransfer)
);

wire [31:0] dataTransfer;
wire [31:0] RAM [265:0] = uut.ram; 

assign dataTransfer = (write == 1)? data : 32'bz;
always #1 clock = ~clock;
always @(posedge clock) 
begin
     if (write == 0) 
     begin
         data <= dataTransfer;
     end
end

initial 
begin 

#1
for (int i=0; i<10; i++) begin
    $display("Testing write");
    write = 1;
    address = 1008 + i*4;
    data = 'h12345670 + i;
    #2
    assert (RAM[(1008 + i*4)/4] == 'h12345670 + i) else $error("RAM[%d] = 0x%x", (1008 + i*4)/4, RAM[(1008 + i*4)/4]);
end

#1
$display("Testing read");
write = 0;
address = 1028;
#2
assert (data == 'h12345675) else $error("data = 0x%x", data);

#5 $finish;
end

endmodule
