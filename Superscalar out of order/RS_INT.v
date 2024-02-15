module RS_INT(

input clk, reset, stall, RS_en1, RS_en2,

input v1_d1, v1_d2, v2_d1, v2_d2,
input [4:0] op_d1, op_d2, dst_d1, dst_d2, tag1_d1, tag1_d2, tag2_d1, tag2_d2, dst_tag_d1, dst_tag_d2, shamt_d1, shamt_d2,
input [31:0] imm_d1, imm_d2, val1_d1, val1_d2, val2_d1, val2_d2,

input we_INT1, we_INT2, we_MUL, we_LW,
input [4:0] tag_INT1, tag_INT2, tag_MUL, tag_LW,
input [31:0] val_INT1, val_INT2, val_MUL, val_LW,

output we_i1, we_i2,
output [4:0] op_i1, op_i2, dst_i1, dst_i2, dst_tag_i1, dst_tag_i2, shamt_i1, shamt_i2,
output [31:0] imm_i1, imm_i2, val1_i1, val1_i2, val2_i1, val2_i2,

output stall_INT

);


	reg        busy 	 [7:0];
		
	reg        we      [7:0];
	
	reg        v1 		 [7:0];
	
	reg 		  v2		 [7:0];
	
	reg [4:0]  op 		 [7:0];
	
	reg [4:0]  shamt   [7:0];
		
	reg [4:0]  dst		 [7:0];
	
	reg [4:0]  tag1 	 [7:0];
	
	reg [4:0]  tag2 	 [7:0];
	
	reg [4:0]  dst_tag [7:0];
	
	reg [31:0] imm		 [7:0];
	
	reg [31:0] val1 	 [7:0];
	
	reg [31:0] val2    [7:0];
	
	
	
	reg [2:0] disp_p1, disp_p2, iss_p1, iss_p2;
	
	
	assign op_i1      = op       [iss_p1];
	
	assign we_i1      = we       [iss_p1];
	
	assign dst_i1     = dst      [iss_p1];
		
	assign dst_tag_i1 = dst_tag  [iss_p1];
	
	assign shamt_i1   = shamt    [iss_p1];
	
	assign imm_i1     = imm      [iss_p1];
	
	assign val1_i1    = val1     [iss_p1];
	
	assign val2_i1    = val2     [iss_p1];
	
	
	assign op_i2      = op       [iss_p2];
	
	assign we_i2      = we       [iss_p2];
	
	assign dst_i2     = dst      [iss_p2];
		
	assign dst_tag_i2 = dst_tag  [iss_p2];
	
	assign shamt_i2   = shamt    [iss_p2];
	
	assign imm_i2     = imm      [iss_p2];
	
	assign val1_i2    = val1     [iss_p2];
	
	assign val2_i2    = val2     [iss_p2];
	
	
	
	always@(posedge clk) begin : MAIN_BLOCK
	
		integer i, j;
		
		reg [2:0] min1, min2, d1, d2;
		
		reg skip1, skip2;
		
		skip1 = 1'b0;
		
		skip2 = 1'b0;
		
		
		if (reset) begin 
		
			for (i = 0; i < 8; i = i + 1) begin
			
				busy    [i] <= 1'b0;
								
				we      [i] <= 1'b0;
				
				v1      [i] <= 1'b0;
				
				v2      [i] <= 1'b0;
				
				op      [i] <= 5'b0;
				
				tag1    [i] <= 5'bx;
				
				tag2    [i] <= 5'bx;
				
				dst     [i] <= 5'b0;
				
				dst_tag [i] <= 5'b0;
				
				shamt   [i] <= 5'b0;
				
				imm     [i] <= 8'b0;
				
				val1    [i] <= 32'b0;
				
				val2    [i]	<= 32'b0;
			
			end
			
			disp_p1 <= 3'b0;
		
			disp_p2 <= 3'b0;
			
			iss_p1  <= 3'b0;
			
			iss_p2  <= 3'b0;
					
		end
		
		else begin
		
			if ((RS_en1 | RS_en2) & ~stall & (~RS_en1 ? ~(dst_d2 == 5'b0) : ~(dst_d1 == 5'b0))) begin
			
				skip1              = ~RS_en1 ? ~(dst_d2 == 5'b0)  : ~(dst_d1 == 5'b0);
		
				busy    [disp_p1] <= ~RS_en1 ? ~(dst_d2 == 5'b0)  : ~(dst_d1 == 5'b0);
									
				v1      [disp_p1] <= ~RS_en1 ? v1_d2              : v1_d1;
				
				v2      [disp_p1] <= ~RS_en1 ? (v2_d2 | op_d2[1]) : (v2_d1 | op_d1[1]);
					
				op      [disp_p1] <= ~RS_en1 ? op_d2              : op_d1;
					
				tag1    [disp_p1] <= ~RS_en1 ? tag1_d2            : tag1_d1;
					
				tag2    [disp_p1] <= ~RS_en1 ? tag2_d2            : tag2_d1;
				 
				dst     [disp_p1] <= ~RS_en1 ? dst_d2             : dst_d1;
				
				dst_tag [disp_p1] <= ~RS_en1 ? dst_tag_d2         : dst_tag_d1;
				
				shamt   [disp_p1] <= ~RS_en1 ? shamt_d2           : shamt_d1;
					
				imm     [disp_p1] <= ~RS_en1 ? imm_d2             : imm_d1;
					
				val1    [disp_p1] <= ~RS_en1 ? val1_d2            : val1_d1;
					
				val2    [disp_p1]	<= ~RS_en1 ? val2_d2            : val2_d1;
				
				we      [disp_p1] <= ~RS_en1 ? ~(dst_d2 == 5'b0)  : ~(dst_d1 == 5'b0);
				
			end
			
			if ((RS_en1 & RS_en2) & ~stall & ~(dst_d2 == 5'b0)) begin
			
				skip2              = ~(dst_d2 == 5'b0);

				busy    [disp_p2] <= ~(dst_d2 == 5'b0);
					
				v1      [disp_p2] <= v1_d2;
				
				v2      [disp_p2] <= v2_d2 | op_d2[1];
					
				op      [disp_p2] <= op_d2;
					
				tag1    [disp_p2] <= tag1_d2;
					
				tag2    [disp_p2] <= tag2_d2;
				 
				dst     [disp_p2] <= dst_d2;
				
				dst_tag [disp_p2] <= dst_tag_d2;
				
				shamt   [disp_p2] <= shamt_d2;
					
				imm     [disp_p2] <= imm_d2;
					
				val1    [disp_p2] <= val1_d2;
					
				val2    [disp_p2]	<= val2_d2;
				
				we      [disp_p2] <= ~(dst_d2 == 5'b0);
				
			end
			
			
			////////////////////Snooping process///////////////////
				
			
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
				
				if ((tag1[j] == tag_MUL) & ~v1[j] & busy[j] & we_MUL) begin
				
					val1 [j]  <= val_MUL;
					
					v1   [j] <= 1'b1;
					
				end
				
				if ((tag2[j] == tag_MUL) & ~v2[j] & busy[j] & we_MUL) begin
			
					val2 [j]  <= val_MUL;		
					
					v2   [j]   <= 1'b1;
					
				end
				
				if ((tag1[j] == tag_LW) & ~v1[j] & busy[j] & we_LW) begin
				
					val1 [j]  <= val_LW;
					
					v1   [j] <= 1'b1;
					
				end
				
				if ((tag2[j] == tag_LW) & ~v2[j] & busy[j] & we_LW) begin
			
					val2 [j]  <= val_LW;		
					
					v2   [j]   <= 1'b1;
					
				end
				
	
			end
			
			///////////////////////////////////////////////////////
			
			
			
			////////////////////////Allocate unit logic////////////////
			
			d1 = 3'd7;
			
			d2 = 3'd7;
			
			for (i = 7; i > 0; i = i - 1) if (~busy[i] & ~((disp_p1 == i) & skip1) & ~((disp_p2 == i) & skip2))              d1 = i[2:0];
			
			for (i = 6; i > 0; i = i - 1) if (~busy[i] & ~(i == d1) & ~((disp_p1 == i) & skip1) & ~((disp_p2 == i) & skip2)) d2 = i[2:0];
			
			if (~busy[0] & ~((disp_p1 == 0) & skip1) & ~((disp_p2 == 0) & skip2)) begin
			
				d2 = d1;
			
				d1 = 3'b0;
			
			end
			
			if (d1 > 3'd5) begin
			
				d1 = iss_p1;
				
				d2 = iss_p2;
			
			end
			
			
			disp_p1 <= d1;
			
			disp_p2 <= d2;			

			//////////////////////////////////////////////
			
			

			
			//////////////Issue unit logic////////////////
			
			
			min1 = 3'd6;
			
			min2 = 3'd6;
			
			for (i = 6; i > 0; i = i - 1) if (busy[i] & v1[i] & v2[i] & ~(i == iss_p1) & ~(i == iss_p2)) min1 = i[2:0];
				
			
			for (i = 6; i > 0; i = i - 1) if (busy[i] & v1[i] & v2[i] & ~(i == min1) & ~(i == iss_p1) & ~(i == iss_p2)) min2 = i[2:0];
				
			
			if (busy[0] & v1[0] & v2[0] & ~(0 == iss_p1) & ~(0 == iss_p2)) begin
			
				min2 = min1;
			
				min1 = 3'b0;
			
			end
			
			iss_p1 <= min1;
			
			iss_p2 <= min2;
			
			
			busy[iss_p1] = 1'b0;
			
			busy[iss_p2] = 1'b0;
			

		end
		
		/////////////////////////////////////////////////////
		
	
	end
	
	assign stall_INT = (disp_p1 > 5'd5) | ((disp_p2 > 5'd5) & (RS_en1 & RS_en2));  // full reservation station

endmodule
