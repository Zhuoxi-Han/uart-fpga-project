module baud_gen(
	input clk,
	input rst,
	output reg baud_tick
);
	
	reg [8:0] counter;
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			counter <= 0;
			baud_tick <= 0;
		end
		else begin
			if(counter == 433) begin
				counter <= 0;
				baud_tick <= 1;
			end
			else begin
				counter <= counter + 1;
				baud_tick <= 0;
			end
		end
	end
	
	endmodule
