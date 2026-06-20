module uart_fpga(
	input CLOCK_50
);

wire baud_tick;

baud_gen baud_inst(
	.clk(CLOCK_50),
	.rst(1'b0),
	.baud_tick(baud_tick)
);

endmodule