module FPU(

input clk, rst,
input op, wr_en_ID,
input [4:0] tag_ID, dst_ID,
input [31:0] A, B,

output reg wr_en_fp,
output reg [4:0] dst_fp, tag_fp,
output reg [31:0] result

);

	wire S_A, S_B;
	
	wire [7:0] exp_A, exp_B;
	
	wire [22:0] frac_A, frac_B;
	
	
	integer shift;
	
	
	reg 
	op_first,
	op_second,
	S_A_first,
	S_B_first,
	S_second,
	S_third,
	S_forth;
	
	reg [7:0]
	exp_A_first,
	exp_B_first,
	exp_second,
	exp_third,
	exp_forth,
	diff_exp_first;
	
	reg [23:0]
	frac_A_first,
	frac_B_first,
	frac_A_second,
	frac_B_second,
	result_frac_forth;
	
	reg [24:0]
	result_frac_third;
	
	
	reg [4:0] tag [3:0];
	
	reg [4:0] dst [3:0];
	
	reg wr_en [3:0];
	
	
	
	
	assign S_A = A[31];
	
	assign S_B = B[31];
	
	assign exp_A = A[30:23];
	
	assign exp_B = B[30:23];
	
	assign frac_A = A[22:0];
	
	assign frac_B = B[22:0];


	always@(posedge clk, posedge rst) begin
	  
	   if (rst) begin

			tag[0] <= 5'b0;
			
			dst[0] <= 5'b0;
			
			wr_en[0] <= 1'b0;
		
			op_first <= 1'b0;
		
			S_A_first <= 1'b0;
			
			S_B_first <= 1'b0;
			
			exp_A_first <= 8'b0;
			
			exp_B_first <= 8'b0;
			
			frac_A_first <= 23'b0;
			
			frac_B_first <= 23'b0;
			
			diff_exp_first <= 8'b0;
	
		end
		
		else begin
	
			tag[0] <= tag_ID;
			
			dst[0] <= dst_ID;
			
			wr_en[0] <= wr_en_ID;
		
			op_first <= op;
		
			S_A_first <= S_A;
			
			S_B_first <= S_B;
			
			exp_A_first <= exp_A;
			
			exp_B_first <= exp_B;
			
			frac_A_first <= {1'b1, frac_A};
			
			frac_B_first <= {1'b1, frac_B};
			
			if (exp_A >= exp_B) diff_exp_first <= exp_A - exp_B;
			
			else diff_exp_first <= exp_B - exp_A;
			
		end
	
	end
	
	always@(posedge clk) begin
	
	
		if (rst) begin
	
			tag[1] <= 5'b0;
			
			dst[1] <= 5'b0;
			
			wr_en[1] <= 1'b0;
		
			op_second <= 1'b0;
	
			S_second <= 1'b0;
		
			frac_A_second <= 24'b0;
				
			frac_B_second <= 24'b0;
						
			exp_second <= 8'b0;
		
		end
		
		else begin
	
			tag[1] <= tag[0];
			
			dst[1] <= dst[0];
			
			wr_en[1] <= wr_en[0];
		
			op_second <= S_A_first ^ S_B_first ^ op_first;
			
			if (exp_A_first >= exp_B_first) begin
			
				if (exp_A_first == exp_B_first) begin
				
					if (frac_A_first >= frac_B_first) begin 
					
						S_second <= S_A_first;
		
						frac_A_second <= frac_A_first;
				
						frac_B_second <= frac_B_first;
						
					end

					else begin
					
						S_second <= S_B_first;
						
						frac_B_second <= frac_A_first;
				
						frac_A_second <= frac_B_first;
						
					end

				end
				
				else begin 
				
					S_second <= S_A_first;
					
					frac_A_second <= frac_A_first;
				
					frac_B_second <= frac_B_first >> diff_exp_first;
					
				end
				
				exp_second <= exp_A_first;
						
			end
			
			else begin
			
				frac_A_second <= frac_B_first;
				
				frac_B_second <= frac_A_first >> diff_exp_first;
				
				exp_second <= exp_B_first;
				
				S_second <= S_B_first; 
			
			end
			
		end

	end
	
	always@(posedge clk) begin
	
		if (rst) begin
		
			tag[2] <= 5'b0;
			
			dst[2] <= 5'b0;
			
			wr_en[2] <= 1'b0;
		
			S_third <= 1'b0;
			
			exp_third <= 8'b0;
			
			result_frac_third <= 25'b0;		
		
		end
		
		else begin
	
			tag[2] <= tag[1];
			
			dst[2] <= dst[1];
			
			wr_en[2] <= wr_en[1];
		
			S_third <= S_second;
			
			exp_third <= exp_second;
			
			if (op_second) result_frac_third <= frac_A_second - frac_B_second;
			
			else result_frac_third <= frac_A_second + frac_B_second;
			
		end
		
	end
	
	always@(posedge clk) begin
	
		if (rst) begin
		
			tag[3] <= 5'b0;
			
			dst[3] <= 5'b0;
			
			wr_en[3] <= 1'b0;

			result_frac_forth <= 23'b0;
				
			exp_forth <= 8'b0;

			S_forth <= 1'b0;
			
		end
		
		else begin
	
			tag[3] <= tag[2];
			
			dst[3] <= dst[2];
			
			wr_en[3] <= wr_en[2];
		
			if (result_frac_third[24]) begin
			
				result_frac_forth <= result_frac_third[24:1];
				
				exp_forth <= exp_third + 8'b1;
				
			end
			
			else begin
			
				result_frac_forth <= result_frac_third[23:0];
				
				exp_forth <= exp_third;	
			
			end
			
			S_forth <= S_third;
			
		end
	
	end
	
	always@(*) begin : normalizer
	
		integer i;
		
		shift = 0;
	
		if (rst) begin
		
			result = 23'b0;
		
			dst_fp <= 5'b0;
			
			tag_fp <= 5'b0;
			
			wr_en_fp <= 1'b0;
		
		end
		
		else begin
		
			for(i = 0; i < 24; i = i + 1) begin
			
				if (result_frac_forth[i]) shift = i;
			
			end
			
			result = {S_forth, exp_forth - (5'd23 - shift[4:0]), result_frac_forth[22:0] << (5'd23 - shift[4:0])};
			
			dst_fp <= dst[3];
			
			tag_fp <= tag[3];
			
			wr_en_fp <= wr_en[3];
			
		end
	
	end

	
endmodule
