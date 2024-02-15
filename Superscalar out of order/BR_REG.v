module BR_REG(

input clk, rst, update_signal_EX, prediction_EX, actual_outcome_EX,
input [4:0] ghr_EX, tag_EX,
input [7:0] next_addr_EX,
input [7:0] b_addr_EX,

output update_signal_R, prediction_R, actual_outcome_R,
output [4:0] ghr_R, tag_R,
output [7:0] next_addr_R,
output [7:0] b_addr_R

);

	reg update_signal, prediction, actual_outcome;
	
	reg [4:0] ghr;
	
	reg [4:0] tag;
	
	reg [7:0] b_addr, next_addr;
	
	
	
	assign update_signal_R   = update_signal;
	
	assign prediction_R      = prediction;
	
	assign actual_outcome_R  = actual_outcome;
	
	assign ghr_R             = ghr;
	
	assign next_addr_R       = next_addr;
	
	assign b_addr_R          = b_addr;
	
	assign tag_R             = tag;
	
	
	
	always@(posedge clk) begin
	
		if (rst) begin
		
			update_signal  <= 1'b0;
			
			prediction     <= 1'b0;
			
			actual_outcome <= 1'b0;
		
			ghr            <= 5'b0;
			
			next_addr      <= 8'b0;
			
			b_addr         <= 8'b0;
			
			tag            <= 5'b0;
			
		
		end
		
		else begin
		
			update_signal  <= update_signal_EX;
		
			prediction     <= prediction_EX;
			
			actual_outcome <= actual_outcome_EX;
			
			ghr            <= ghr_EX;
			
			tag            <= tag_EX;
			
			next_addr      <= next_addr_EX;
			
			b_addr         <= b_addr_EX;
			
		
		end
	
	
	end

endmodule
