module ROB(

input clk, rst, stall, we_INT1, we_INT2, we_MUL, we_FP, we_LW, we_SW, update_signal_BR, prediction_BR, actual_outcome_BR, nop, inc1,
input [4:0] dst_tag_INT1, dst_tag_INT2, dst_tag_MUL, dst_tag_FP, dst_tag_LW, dst_tag_SW, dst_tag_BR, dst_INT1, dst_INT2, dst_MUL, dst_FP, dst_LW, ghr_BR, first_tag1, first_tag2, second_tag1, second_tag2,
input [7:0] next_addr_BR,
input [7:0] b_addr_BR,
input [31:0] data_INT1, data_INT2, data_MUL, data_FP, data_LW,

output we_C1, we_C2, we_f_C1, we_f_C2, sw_en_C1, sw_en_C2, update_signal_C1, update_signal_C2, prediction_C1, prediction_C2, actual_outcome_C1, actual_outcome_C2,
output [4:0] wr_addr_C1, wr_addr_C2, ghr_C1, ghr_C2,
output [7:0] next_addr_C1, next_addr_C2,
output [7:0] b_addr_C1, b_addr_C2,
output [31:0] wr_data_C1, wr_data_C2,

output [31:0] first_operand1, first_operand2, second_operand1, second_operand2,

output reg [4:0] wr_p, rd_p,
output stall_ROB

);


	reg        we             [31:0];
	
	reg        actual_outcome [31:0];
	
	reg        prediction     [31:0];
	
	reg        update_signal  [31:0];
	
	reg        we_f    		  [31:0];
	
	reg        sw_en          [31:0];
	
	reg [4:0]  wr_addr        [31:0];
	
	reg [31:0] wr_data        [31:0];

	
	assign we_C1             = we             [rd_p];
	
	assign actual_outcome_C1 = actual_outcome [rd_p];
	
	assign prediction_C1     = prediction     [rd_p];
	
	assign update_signal_C1  = update_signal  [rd_p];
	
	assign we_f_C1           = we_f           [rd_p];
	
	assign sw_en_C1          = sw_en          [rd_p];
	
	assign wr_addr_C1        = wr_addr        [rd_p];
	
	assign ghr_C1            = wr_addr        [rd_p];
	
	assign b_addr_C1         = wr_data        [rd_p][15:8];
	
	assign next_addr_C1      = wr_data        [rd_p][7:0];
	
	assign wr_data_C1        = wr_data        [rd_p];
	
	
	assign we_C2             = we             [rd_p + 5'b1];
	
	assign actual_outcome_C2 = actual_outcome [rd_p + 5'b1];
	
	assign prediction_C2     = prediction     [rd_p + 5'b1];
	
	assign update_signal_C2  = update_signal  [rd_p + 5'b1];
	
	assign we_f_C2           = we_f           [rd_p + 5'b1];
	
	assign sw_en_C2          = sw_en          [rd_p + 5'b1];
	
	assign wr_addr_C2        = wr_addr        [rd_p + 5'b1];
	
	assign ghr_C2            = wr_addr        [rd_p + 5'b1];
	
	assign b_addr_C2         = wr_data        [rd_p + 5'b1][15:8];
	
	assign next_addr_C2      = wr_data        [rd_p + 5'b1][7:0];
	
	assign wr_data_C2        = wr_data        [rd_p + 5'b1];
	
	
	assign first_operand1    = wr_data        [first_tag1];
	
	assign second_operand1   = wr_data        [second_tag1];
	
	assign first_operand2    = wr_data        [first_tag2];
	
	assign second_operand2   = wr_data        [second_tag2];
	
	
	always@(posedge clk) begin : MAIN_BLOCK
	
		integer i;
	
		if (rst) begin
		
			for (i = 0; i < 32; i = i + 1) begin
			
				we             [i] <= 1'b0;
				
				actual_outcome [i] <= 1'b0;
				
				prediction     [i] <= 1'b0;
				
				update_signal  [i] <= 1'b0;
				 
				sw_en          [i] <= 1'b0;
				
				we_f           [i] <= 1'b0;
				
				wr_addr        [i] <= 5'b0;
				
				wr_data        [i] <= 32'b0;
			
			end
			
			wr_p <= 5'b0;
			
			rd_p <= 5'b0;
				
		end
		
		else begin
					
				if (we_INT1) begin
				
					we      			[dst_tag_INT1] <= we_INT1;
				
					wr_addr 			[dst_tag_INT1] <= dst_INT1;
					
					wr_data 			[dst_tag_INT1] <= data_INT1;
					
				end
				
				if (we_INT2) begin
				
					we      			[dst_tag_INT2] <= we_INT2;
					
					wr_addr 			[dst_tag_INT2] <= dst_INT2;
					
					wr_data 			[dst_tag_INT2] <= data_INT2;
					
				end
				
				if (we_MUL) begin
				
					we      			[dst_tag_MUL] <= we_MUL;
					
					wr_addr 			[dst_tag_MUL] <= dst_MUL;
					
					wr_data 			[dst_tag_MUL] <= data_MUL;
				
				end
				
				if (we_FP) begin
				
					we_f   		   [dst_tag_FP] <= we_FP;
					
					wr_addr        [dst_tag_FP] <= dst_FP;
					
					wr_data        [dst_tag_FP] <= data_FP;
					
									
				end
				
				if (we_SW) begin
				
					sw_en          [dst_tag_SW] <= we_SW;
				
				end
				
				if (we_LW) begin
				
					we             [dst_tag_LW] <= we_LW;
					
					wr_addr        [dst_tag_LW] <= dst_LW;
					
					wr_data        [dst_tag_LW] <= data_LW;
				
				end
				
				if (update_signal_BR) begin
				
					update_signal  [dst_tag_BR]       <= update_signal_BR;
					
					prediction     [dst_tag_BR]       <= prediction_BR;
					
					actual_outcome [dst_tag_BR]       <= actual_outcome_BR;
					
					wr_addr        [dst_tag_BR]       <= ghr_BR;
					
					wr_data        [dst_tag_BR][15:8] <= b_addr_BR;
					
					wr_data        [dst_tag_BR][7:0]  <= next_addr_BR;

				
				end
				
			
			
			if ((we[rd_p] | we_f[rd_p] | sw_en[rd_p] | update_signal[rd_p])) begin
			
				if (sw_en[rd_p]) rd_p <= rd_p + 5'b1;
				
				else if ((we[rd_p + 5'b1] | we_f[rd_p + 5'b1] | sw_en[rd_p + 5'b1] | update_signal[rd_p + 5'b1])) rd_p <= rd_p + 5'd2;
							
			end
			
			
			if (~stall & ~nop & inc1) begin
			
				wr_p <= wr_p + 5'b1;
				
				we             [wr_p] <= 1'b0;
				
				actual_outcome [wr_p] <= 1'b0;
				
				prediction     [wr_p] <= 1'b0;
				
				update_signal  [wr_p] <= 1'b0;
				 
				sw_en          [wr_p] <= 1'b0;
				
				we_f           [wr_p] <= 1'b0;
				
				wr_addr        [wr_p] <= 5'b0;
				
				wr_data        [wr_p] <= 32'b0;
				
			end
			
			else if (~stall & ~nop) begin
		
				wr_p <= wr_p + 5'd2;

				we             [wr_p] <= 1'b0;
				
				actual_outcome [wr_p] <= 1'b0;
				
				prediction     [wr_p] <= 1'b0;
				
				update_signal  [wr_p] <= 1'b0;
				 
				sw_en          [wr_p] <= 1'b0;
				
				we_f           [wr_p] <= 1'b0;
				
				wr_addr        [wr_p] <= 5'b0;
				
				wr_data        [wr_p] <= 32'b0;
				
				we             [wr_p + 5'b1] <= 1'b0;
				
				actual_outcome [wr_p + 5'b1] <= 1'b0;
				
				prediction     [wr_p + 5'b1] <= 1'b0;
				
				update_signal  [wr_p + 5'b1] <= 1'b0;
				 
				sw_en          [wr_p + 5'b1] <= 1'b0;
				
				we_f           [wr_p + 5'b1] <= 1'b0;
				
				wr_addr        [wr_p + 5'b1] <= 5'b0;
				
				wr_data        [wr_p + 5'b1] <= 32'b0; 
				
			end
		
		
		end
	
	
	end
	
	assign stall_ROB = ((wr_p + 5'd2) == rd_p) | ((wr_p + 5'b1) == rd_p);



endmodule
