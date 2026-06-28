`timescale 1ns/1ps

module baud_gen_tb;

reg clk;
reg rst;
wire baud_tick;

baud_gen dut(
	.clk(clk),
	.rst(rst),
	.baud_tick(baud_tick)
);

always #10 clk = ~clk;

initial begin
	clk = 0;
	rst = 0;
	#10;
	
	rst = 1;#10;
	rst = 0;#10;
	
	#100;
	rst = 0;
	
	#50000;
	$stop;
end

endmodule