module INST_REG(

input clk, rst, stall, second_flush,

input first_prediction_F, second_prediction_F, first_branch_F, second_branch_F,
input [4:0] ghr_F,
input [7:0] first_next_addr_F, second_next_addr_F,
input [7:0] first_target_addr_F, second_target_addr_F,
input [31:0] first_F, second_F,


output first_prediction_D, second_prediction_D, first_branch_D, second_branch_D,
output [4:0] ghr_D,
output [7:0] first_next_addr_D, second_next_addr_D,
output [7:0] first_target_addr_D, second_target_addr_D,
output [31:0] first_D, second_D

);

	reg first_prediction, second_prediction, first_branch, second_branch;
	
	reg [4:0] ghr;
	
	reg [7:0] first_next_addr, second_next_addr, first_target_addr, second_target_addr;
	
	reg [31:0] first_inst, second_inst;
	
	
	assign first_prediction_D     = first_prediction;
	
	assign second_prediction_D    = second_prediction;
	
	assign first_branch_D         = first_branch;
	
	assign second_branch_D        = second_branch;
	
	assign ghr_D                  = ghr;
	
	assign first_next_addr_D      = first_next_addr;
	
	assign second_next_addr_D     = second_next_addr;
	
	assign first_target_addr_D    = first_target_addr;
	
	assign second_target_addr_D   = second_target_addr;  
	
	assign first_D                = first_inst;
	
   assign second_D               = second_inst;	
	
	
	always@(posedge clk) begin
	
		if (rst) begin
		
			first_prediction   <= 1'b0;
			
			second_prediction  <= 1'b0;
			
			first_branch       <= 1'b0;
			
			second_branch      <= 1'b0;
			
			ghr                <= 5'b0;
			
			first_next_addr    <= 8'b0;
			
			second_next_addr   <= 8'b0;
			
			first_target_addr  <= 8'b0;
			
			second_target_addr <= 8'b0;
		
			first_inst         <= 0;
			
			second_inst        <= 0;
		
		end
		
		else if (~stall) begin
		
			if (second_flush) begin
							
				second_prediction  <= 1'b0;
								
				second_branch      <= 1'b0;
												
				second_next_addr   <= 8'b0;
								
				second_target_addr <= 8'b0;
							
				second_inst        <= 32'b0;
								
			
			end
			
			else begin
							
				second_prediction  <= second_prediction_F;
								
				second_branch      <= second_branch_F;
								
				second_next_addr   <= second_next_addr_F;
								
				second_target_addr <= second_target_addr_F;
							
				second_inst        <= second_F;
				
			end
		
			first_prediction   <= first_prediction_F;
						
			first_branch       <= first_branch_F;
						
			ghr                <= ghr_F;
			
			first_next_addr    <= first_next_addr_F;
						
			first_target_addr  <= first_target_addr_F;
					
			first_inst         <=  first_F;
						
		
		end
	
	end
	
endmodule
