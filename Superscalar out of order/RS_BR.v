module RS_BR(

input clk, reset, stall, RS_en1, RS_en2,

input v1_d1, v1_d2, v2_d1, v2_d2,
input prediction_d1, prediction_d2,
input [2:0] b_cont_d1, b_cont_d2,
input [4:0] ghr_d1, ghr_d2, tag1_d1, tag1_d2, tag2_d1, tag2_d2, dst_tag_d1, dst_tag_d2,
input [7:0] next_addr_d1, next_addr_d2,
input [7:0] b_addr_d1, b_addr_d2,
input [31:0] val1_d1, val1_d2, val2_d1, val2_d2,

input we_INT1, we_INT2, we_MUL, we_LW,
input [4:0] tag_INT1, tag_INT2, tag_MUL, tag_LW,
input [31:0] val_INT1, val_INT2, val_MUL, val_LW,

output update_signal_i, prediction_i,
output [2:0] b_cont_i,
output [4:0] ghr_i,dst_tag_i,
output [7:0] next_addr_i,
output [7:0] b_addr_i,
output [31:0]  val1_i, val2_i,
output stall_BR

);


	reg        busy 	            [7:0];
	
	reg        update_signal      [7:0];
	
	reg        prediction         [7:0];
		
	reg        v1 		            [7:0];
	
	reg 		  v2		            [7:0];
	
	reg [2:0]  b_cont             [7:0];
				
	reg [4:0]  ghr		            [7:0];
	
	reg [4:0]  tag1 	            [7:0];
	
	reg [4:0]  tag2 	            [7:0];
	
	reg [4:0]  dst_tag            [7:0];
	
	reg [7:0]  next_addr          [7:0];
	
	reg [7:0]  b_addr             [7:0];
		
	reg [31:0] val1 	            [7:0];
	
	reg [31:0] val2               [7:0];
	
	
	
	reg [2:0] disp_p1, disp_p2, iss_p;
	
	
		
	assign update_signal_i  = update_signal[iss_p];
	
	assign prediction_i     = prediction[iss_p];
	
	assign b_cont_i         = b_cont[iss_p];
		
	assign ghr_i            = ghr[iss_p];
		
	assign dst_tag_i        = dst_tag[iss_p];
	
	assign next_addr_i      = next_addr[iss_p];
	
	assign b_addr_i         = b_addr[iss_p];
	
	assign val1_i           = val1[iss_p];
	
	assign val2_i           = val2[iss_p];
	
	
	
	
	always@(posedge clk) begin : MAIN_BLOCK
	
		integer i, j;
		
		reg [2:0] min, d1, d2;
		
		reg skip1, skip2;
		
		skip1 = 1'b0;
		
		skip2 = 1'b0;
		
		
		if (reset) begin 
		
			for (i = 0; i < 8; i = i + 1) begin
			
				busy               [i] <= 1'b0;
				
				update_signal      [i] <= 1'b0;
				
				prediction         [i] <= 1'b0;
								
				v1                 [i] <= 1'b1;
				
				v2                 [i] <= 1'b1;
				
				b_cont             [i] <= 3'b0;
								
				tag1               [i] <= 5'b0;
				
				tag2               [i] <= 5'b0;
				
				ghr                [i] <= 5'b0;
				
				dst_tag            [i] <= 5'b0;
				
				b_addr             [i] <= 8'b0;
				
				val1               [i] <= 32'b0;
				
				val2               [i] <= 32'b0;
			
			end
			
			disp_p1 <= 3'b0;
		
			disp_p2 <= 3'b0;
			
			iss_p   <= 3'b0;
		
		end
		
		else begin
		
			if ((RS_en1 | RS_en2) & ~stall) begin
			
				skip1 = 1'b1;
		
				busy           [disp_p1] <= 1'b1;
				
				update_signal  [disp_p1] <= 1'b1;
				
				prediction     [disp_p1] <= ~RS_en1 ? prediction_d2 : prediction_d1;
									
				v1             [disp_p1] <= ~RS_en1 ? v1_d2 : v1_d1;
				
				v2             [disp_p1] <= ~RS_en1 ? v2_d2 : v2_d1;
				
				b_cont         [disp_p1] <= ~RS_en1 ? b_cont_d2 : b_cont_d1;
										
				tag1           [disp_p1] <= ~RS_en1 ? tag1_d2 : tag1_d1;
					
				tag2           [disp_p1] <= ~RS_en1 ? tag2_d2 : tag2_d1;
				 
				ghr            [disp_p1] <= ~RS_en1 ? ghr_d2 : ghr_d1;
				
				dst_tag        [disp_p1] <= ~RS_en1 ? dst_tag_d2 : dst_tag_d1;
				
				next_addr      [disp_p1] <= ~RS_en1 ? next_addr_d2 : next_addr_d1;
				
				b_addr         [disp_p1] <= ~RS_en1 ? b_addr_d2 : b_addr_d1;
														
				val1           [disp_p1] <= ~RS_en1 ? val1_d2 : val1_d1;
					
				val2           [disp_p1] <= ~RS_en1 ? val2_d2 : val2_d1;
								
			end
			
			if (RS_en1 & RS_en2 & ~stall) begin
			
				skip2 = 1'b1;
			
				busy           [disp_p2] <= 1'b1;
		
				v1             [disp_p2] <= v1_d2;
				
				v2             [disp_p2] <= v2_d2;

				update_signal  [disp_p2] <= 1'b1;
				
				prediction     [disp_p2] <= prediction_d2;
				
				b_cont         [disp_p2] <= b_cont_d2;
														
				tag1           [disp_p2] <= tag1_d2;
					
				tag2           [disp_p2] <= tag2_d2;
				
				ghr            [disp_p2] <= ghr_d2;
				
				dst_tag        [disp_p2] <= dst_tag_d2;
				
				next_addr      [disp_p2] <= next_addr_d2;
				
				b_addr         [disp_p2] <= b_addr_d2;

				val1           [disp_p2] <= val1_d2;
					
				val2           [disp_p2] <= val2_d2;
								
			end
				
			
			for (j = 0; j < 6; j = j + 1) begin : SNOOPING
			
			
				if ((tag1[j] == tag_INT1) & ~v1[j] & busy[j] & we_INT1) begin 
				
					val1 [j] <= val_INT1;
					
					v1   [j] <= 1'b1;
					
				end
				
				if ((tag2[j] == tag_INT1) & ~v2[j] & busy[j] & we_INT1) begin
			
					val2 [j] <= val_INT1;
					
					v2   [j] <= 1'b1;
					
				end
				
				if ((tag1[j] == tag_INT2) & ~v1[j] & busy[j] & we_INT2) begin
			
					val1 [j] <= val_INT2;
					
					v1   [j] <= 1'b1;
					
				end
				
				if ((tag2[j] == tag_INT2) & ~v2[j] & busy[j] & we_INT2) begin
			
					val2 [j] <= val_INT2;
					
					v2   [j] <= 1'b1;
					
				end
				
				if ((tag1[j] == tag_MUL) & ~((j == disp_p1) | (j == disp_p2)) & ~v1[j] & busy[j] & we_MUL) begin
				
					val1 [j]  <= val_MUL;
					
					v1   [j] <= 1'b1;
					
				end
				
				if ((tag2[j] == tag_MUL) & ~((j == disp_p1) | (j == disp_p2)) & ~v2[j] & busy[j] & we_MUL) begin
			
					val2 [j]  <= val_MUL;		
					
					v2   [j]   <= 1'b1;
					
				end
				
				if ((tag1[j] == tag_LW) & ~((j == disp_p1) | (j == disp_p2)) & ~v1[j] & busy[j] & we_LW) begin
				
					val1 [j]  <= val_LW;
					
					v1   [j] <= 1'b1;
					
				end
				
				if ((tag2[j] == tag_LW) & ~((j == disp_p1) | (j == disp_p2)) & ~v2[j] & busy[j] & we_LW) begin
			
					val2 [j]  <= val_LW;		
					
					v2   [j]   <= 1'b1;
					
				end
				
	
			end
			
			d1 = 3'd7;
			
			d2 = 3'd7;
			
			
			for (i = 7; i > 0; i = i - 1) if (~busy[i] & ~((disp_p1 == i) & skip1) & ~((disp_p2 == i) & skip2)) d1 = i[2:0];
			
			for (i = 6; i > 0; i = i - 1) if (~busy[i] & ~(i == d1) & ~((disp_p1 == i) & skip1) & ~((disp_p2 == i) & skip2)) d2 = i[2:0];
			
			if (~busy[0] & ~((disp_p1 == 0) & skip1) & ~((disp_p2 == 0) & skip2)) begin
			
				d2 = d1;
			
				d1 = 3'b0;
			
			end
			
			else if (d1 > 3'd5) d1 = iss_p;
			
			disp_p1 <= d1;
			
			disp_p2 <= d2;
			
			
			
			min = 3'd6;
			
			
			for (i = 6; i > 0; i = i - 1) if (busy[i] & v1[i] & v2[i] & ~(i == iss_p)) min = i[2:0];
								
			
			if (busy[0] & v1[0] & v2[0] & ~(0 == iss_p)) min = 3'b0;
			
			
			iss_p <= min;
			
			busy[iss_p] <= 1'b0;
			
			
			
		end
		
	
	end
	
	assign stall_BR = (disp_p1 > 3'd5);
	

endmodule
