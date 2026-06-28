`timescale 1ns/1ps

module uart_tx_tb;

reg clk;
reg rst;
reg baud_tick;
reg tx_start;
reg [7:0] data_in;

wire tx;
wire tx_busy;

uart_tx dut(
	.clk(clk),
	.rst(rst),
	.baud_tick(baud_tick),
	.tx_start(tx_start),
	.data_in(data_in),
	.tx(tx),
	.tx_busy(tx_busy)
);

// 50 MHz clock
always #10 clk = ~clk;

// generate baud_tick every 200 ns
always begin
	baud_tick = 0; #180;
	baud_tick = 1; #20;
end

initial begin
	clk = 0;
	rst = 1;
	tx_start = 0;
	data_in = 8'h00;
	#100;
	
	rst = 0;#100;
	
	// 8'hFE = 1111_1110
	// LSB 0111_1111
	@(posedge clk);
	data_in = 8'b1111_0001;
	tx_start = 1;
	
	@(posedge clk);
	tx_start = 0;
	
	#5000;
	
	$stop;
end

endmodule