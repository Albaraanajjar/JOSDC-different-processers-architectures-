module RS_FP(

input clk, reset, RS_en1, RS_en2,

input op_d1, op_d2, v1_d1, v1_d2, v2_d1, v2_d2,
input [4:0] dst_d1, dst_d2, tag1_d1, tag1_d2, tag2_d1, tag2_d2, dst_tag_d1, dst_tag_d2,
input [31:0] val1_d1, val1_d2, val2_d1, val2_d2,

input we_FP,
input [4:0] tag_FP,
input [31:0] val_FP,

output we_i, op_i,
output [4:0] dst_i, dst_tag_i,
output [31:0]  val1_i, val2_i,
output stall

);


	reg        busy 	 [3:0];
	
	reg        we      [3:0];
	
	reg        op      [3:0];
	
	reg        v1 		 [3:0];
	
	reg 		  v2		 [3:0];
				
	reg [4:0]  dst		 [3:0];
	
	reg [4:0]  tag1 	 [3:0];
	
	reg [4:0]  tag2 	 [3:0];
	
	reg [4:0]  dst_tag [3:0];
		
	reg [31:0] val1 	 [3:0];
	
	reg [31:0] val2    [3:0];
	
	
	
	reg [1:0] disp_p1, disp_p2, iss_p;
	
		
	assign we_i      = we[iss_p];
	
	assign op_i      = op[iss_p];
	
	assign dst_i     = dst[iss_p];
		
	assign dst_tag_i = dst_tag[iss_p];
	
	assign val1_i    = val1[iss_p];
	
	assign val2_i    = val2[iss_p];
	
	
	
	
	always@(posedge clk) begin : MAIN_BLOCK
	
		integer i, j;
		
		reg [1:0] min, d1, d2;
		
		reg skip1, skip2;
		
		skip1 = 1'b0;
		
		skip2 = 1'b0;
		
		
		if (reset) begin 
		
			for (i = 0; i < 4; i = i + 1) begin
			
				busy    [i] <= 1'b0;
				
				we      [i] <= 1'b0;
				
				op      [i] <= 1'b0;
				
				v1      [i] <= 1'b1;
				
				v2      [i] <= 1'b1;
								
				tag1    [i] <= 5'b0;
				
				tag2    [i] <= 5'b0;
				
				dst     [i] <= 5'b0;
				
				dst_tag [i] <= 5'b0;
				
				val1    [i] <= 32'b0;
				
				val2    [i]	<= 32'b0;
			
			end
			
			disp_p1 <= 2'b0;
		
			disp_p2 <= 2'b0;
			
			iss_p   <= 2'b0;
		
		end
		
		else begin
		
			if ((disp_p1 < 2'd3) & (RS_en1 | RS_en2) & ~stall) begin
			
				skip1              = 1'b1;
		
				busy    [disp_p1] <= 1'b1;
					
				v1      [disp_p1] <= ~RS_en1 ? v1_d2      : v1_d1;
				
				v2      [disp_p1] <= ~RS_en1 ? v2_d2      : v2_d1;
				
				op      [disp_p1] <= ~RS_en1 ? op_d2      : op_d1;
										
				tag1    [disp_p1] <= ~RS_en1 ? tag1_d2    : tag1_d1;
					
				tag2    [disp_p1] <= ~RS_en1 ? tag2_d2    : tag2_d1;
				 
				dst     [disp_p1] <= ~RS_en1 ? dst_d2     : dst_d1;
				
				dst_tag [disp_p1] <= ~RS_en1 ? dst_tag_d2 : dst_tag_d1;
														
				val1    [disp_p1] <= ~RS_en1 ? val1_d2    : val1_d1;
					
				val2    [disp_p1]	<= ~RS_en1 ? val2_d2    : val2_d1;
				
				we      [disp_p1] <= 1'b1;
				
			end
			
			if ((disp_p2 < 2'd3) & RS_en2 & RS_en1 & ~stall) begin
			
			   skip2              = 1'b1;
			
				busy    [disp_p2] <= 1'b1;
		
				v1      [disp_p2] <= v1_d2;
				
				v2      [disp_p2] <= v2_d2;
				
				op      [disp_p2] <= op_d2;
										
				tag1    [disp_p2] <= tag1_d2;
					
				tag2    [disp_p2] <= tag2_d2;
				
				dst     [disp_p2] <= dst_d2;
				
				dst_tag [disp_p2] <= dst_tag_d2;
					
				val1    [disp_p2] <= val1_d2;
					
				val2    [disp_p2]	<= val2_d2;
				
				we      [disp_p2] <= 1'b1;
				
			end
				
			
			for (j = 0; j < 3; j = j + 1) begin : SNOOPING
			
			
				if ((tag1[j] == tag_FP) & ~((j == disp_p1) | (j == disp_p2)) & ~v1[j] & busy[j] & we_FP) begin 
				
					val1 [j] <= val_FP;
					
					v1   [j] <= 1'b1;
					
				end
				
				if ((tag2[j] == tag_FP) & ~((j == disp_p1) | (j == disp_p2)) & ~v2[j] & busy[j] & we_FP) begin
			
					val2 [j] <= val_FP;
					
					v2   [j] <= 1'b1;
					
				end
				
	
			end
			
			
			d1 = 2'd3;
			
			d2 = 2'd3;
			
			
			
			for (i = 3; i > 0; i = i - 1) if (~busy[i] & ~((disp_p1 == i) & skip1) & ~((disp_p2 == i) & skip2))              d1 = i[1:0];
			
			for (i = 3; i > 0; i = i - 1) if (~busy[i] & ~(i == d1) & ~((disp_p1 == i) & skip1) & ~((disp_p2 == i) & skip2)) d2 = i[1:0];
			
			
			
			if (~busy[0] & ~((disp_p1 == 0) & skip1) & ~((disp_p2 == 0) & skip2)) begin
			
				d2 = d1;
			
				d1 = 2'b0;
			
			end
			
			if (d1 == 2'd3) d1 = iss_p;
				
			
			
			
			disp_p1 <= d1;
			
			disp_p2 <= d2;	
			
			
			min = 2'd3;
			
			
			for (i = 3; i > 0; i = i - 1) if (busy[i] & v1[i] & v2[i] & ~(i == iss_p)) min = i[1:0];
				
			
				
			
			if (busy[0] & v1[0] & v2[0] & ~(0 == iss_p)) min = 2'b0;
			
			
			iss_p <= min;
			
			
			
			busy[iss_p] = 1'b0;
			
		end
		
	
	end
	
	assign stall = (disp_p1 == 2'd3) | (disp_p2 == 2'd3);
	

endmodule
