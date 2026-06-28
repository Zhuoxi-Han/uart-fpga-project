module uart_tx(
	input clk,
	input rst,
	
	input baud_tick,
	
	input tx_start,
	input [7:0] data_in,
	
	output reg tx,
	output reg tx_busy
);
	localparam IDLE = 2'b00;
	localparam START = 2'b01;
	localparam DATA = 2'b10;
	localparam STOP = 2'b11;
	
	reg [1:0] state;
	reg [2:0] bit_index;
	reg [7:0] shift_reg;

	// latch start detection
	reg tx_start_d;

	always @(posedge clk) begin
		tx_start_d <= tx_start;
	end
	
	wire tx_start_pulse = tx_start & ~tx_start_d;
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			state <= 0;
			tx <= 1;
			tx_busy <= 0;
			bit_index <= 0;
			shift_reg <= 0;
		end else begin
			case(state)
				IDLE: begin
				tx <= 1;
				tx_busy <= 0;
				bit_index <= 0;
				shift_reg <= 0;
				if(tx_start_pulse) begin
					tx_busy <= 1;
					state <= START;
					end
				end
					
				START: begin
					tx <= 0;
					shift_reg <= data_in;
					if(baud_tick) begin
						state <= DATA;
					end 
				end
					
				DATA: begin
					if(baud_tick) begin
						tx <= shift_reg[0];
						shift_reg <= shift_reg >> 1;
						
						if(bit_index == 7) begin
							state <= STOP;
						end else begin
							bit_index <= bit_index + 1;
						end
					end
				end
					
				STOP: begin
					tx <= 1;
					if(baud_tick) begin
						state <= IDLE;
						tx_busy <= 0;
					end
				end
					
			endcase
			
		end
	end
endmodule

