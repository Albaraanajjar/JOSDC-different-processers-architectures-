module sw_buffer(

input clk, rst, inc, we,
input [9:0] addr_i,
input [31:0] data_i,

output reg lw_en,
output reg [31:0] lw_data,

output sw_m,
output [9:0] addr_m,
output [31:0] data_m,
output reg stall

);


	reg [9:0]  addr [3:0];
	
	reg [31:0] data [3:0];
	
	reg        sw   [3:0];
	
	
	reg [1:0] wr_p, rd_p;
	
	
	assign data_m = data[rd_p];
	
	assign addr_m = addr[rd_p];
	
	assign sw_m   = sw  [rd_p];
	
	always@(posedge clk) begin : MAIN_BLOCK
	
		integer i;
	
		if (rst) begin
		
			for (i = 0; i < 4; i = i + 1) begin
			
				sw   [i] <= 1'b0;
			
				addr [i] <= 10'b0;
				
				data [i] <= 32'b0;
		
			end
			
			wr_p <= 2'b0;
			
			rd_p <= 2'b0;
			
			stall <= 1'b0;
		
		end
		
		else begin
		
			if (we & ~stall) begin
			
				data [wr_p] <= data_i;
				
				addr [wr_p] <= addr_i;
				
				sw   [wr_p] <= we;
			
			end
			
			lw_en = 1'b1;
			
			if      ((addr_i == addr[0]) & sw[0]) lw_data <= data[0];
			
			else if ((addr_i == addr[1]) & sw[1]) lw_data <= data[1];
			
			else if ((addr_i == addr[2]) & sw[2]) lw_data <= data[2];
			
			else if ((addr_i == addr[3]) & sw[3]) lw_data <= data[3];
			
			else 								           lw_en    = 1'b0;
			
			if (inc) begin 
			
				rd_p <= rd_p + 2'b1;
				
				sw[rd_p] <= 1'b0;
				
			end
			
			if (we & ~stall) wr_p <= wr_p + 2'b1;
						
			stall <= 1'b0;
		
		end
	
	end

endmodule
