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

always #1 clock = ~clock;


wire [31:0] dataTransfer;
assign dataTransfer = (write == 1)? data : 32'bz;
always @(posedge clock) 
begin
     if (write == 0) 
     begin
         data <= dataTransfer;
     end
end


wire [31:0] RAM [1023:0] = uut.ram; 


initial 
begin 

#1
for (int i=1010; i<1020; i++) begin
    $display("Testing write");
    write = 1;
    address = i;
    data = 'h12345670 + (i%10);
    #2
    assert (RAM[i] == 'h12345670 + (i%10)) else $error("RAM[%d] = 0x%x", i, RAM[i]);
end

#1
$display("Testing read");
write = 0;
address = 1015;
#2
assert (data == 'h12345675) else $error("data = 0x%x", data);



#5 $finish;




end

endmodule
