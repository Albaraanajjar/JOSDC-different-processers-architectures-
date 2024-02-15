module RS_MEM(

input clk, rst, RS_en1, RS_en2, stop,

input v1_d1, v1_d2, v2_d1, v2_d2, lw_d1, lw_d2, sw_d1, sw_d2,
input [4:0] dst_d1, dst_d2, tag1_d1, tag1_d2, tag2_d1, tag2_d2, dst_tag_d1, dst_tag_d2,
input [31:0] imm_d1, imm_d2, val_d1, val_d2, data_d1, data_d2,

input we_INT1, we_INT2, we_MUL, we_LW,
input [4:0] tag_INT1, tag_INT2, tag_MUL, tag_LW,
input [31:0] val_INT1, val_INT2, val_MUL, val_LW,

output lw_i, sw_i,
output [4:0] dst_i, dst_tag_i,
output [31:0]  imm_i, val_i, data_i,
output stall

);

	reg        v1      [7:0];
	
	reg        v2      [7:0];

	reg        lw      [7:0];
	
	reg        sw      [7:0];

	reg [4:0]  tag1    [7:0];
	
	reg [4:0]  tag2    [7:0];
	
	reg [4:0]  dst_tag [7:0];
	
	reg [4:0]  dst     [7:0];
	
	reg [31:0] imm     [7:0];
	
	reg [31:0] val     [7:0];
	
	reg [31:0] data    [7:0];
	
	
	reg [2:0] wr_p, rd_p;
	
	
	
	assign lw_i      = lw      [rd_p] & v1[rd_p] & v2[rd_p];
	
	assign sw_i      = sw      [rd_p] & v1[rd_p] & v2[rd_p];
	
	assign dst_tag_i = dst_tag [rd_p];
	
	assign dst_i     = dst     [rd_p];
	
	assign imm_i     = imm     [rd_p];
	
	assign val_i     = val     [rd_p];
	
	assign data_i    = data    [rd_p];


	always@(posedge clk) begin : MAIN_BLOCK
	
	
		integer i;
		
		if (rst) begin : RESET
		
			for (i = 0; i < 8; i = i + 1) begin
			
				v1      [i] <= 1'b0;
				
				v2      [i] <= 1'b0;
			
				lw      [i] <= 1'b0;
				
				sw      [i] <= 1'b0;
				
				tag1    [i] <= 5'bx;
				
				tag2    [i] <= 5'bx;
				
				dst_tag [i] <= 5'b0;
				
				dst     [i] <= 5'b0;
				
				imm     [i] <= 32'b0;
				
				val     [i] <= 32'b0;
				
				data    [i] <= 32'b0;
			
			end
			
			wr_p <= 3'b0;
			
			rd_p <= 3'b0;
			
		end
		
		else begin : EXCUTE
		
			if (~stall & (RS_en1 | RS_en2)) begin
			
				v1      [wr_p] <= ~RS_en1 ? v1_d2           : v1_d1;
				
				v2      [wr_p] <= ~RS_en1 ? (v2_d2 | lw_d2) : (v2_d1 | lw_d1);
			
				lw      [wr_p] <= ~RS_en1 ? lw_d2           : lw_d1;
				
				sw      [wr_p] <= ~RS_en1 ? sw_d2           : sw_d1;
				
				tag1    [wr_p] <= ~RS_en1 ? tag1_d2         : tag1_d1;
				
				tag2    [wr_p] <= ~RS_en1 ? tag2_d2         : tag2_d1;
				
				dst_tag [wr_p] <= ~RS_en1 ? dst_tag_d2      : dst_tag_d1;
				
				dst     [wr_p] <= ~RS_en1 ? dst_d2          : dst_d1;
				
				imm     [wr_p] <= ~RS_en1 ? imm_d2          : imm_d1;
				
				val     [wr_p] <= ~RS_en1 ? val_d2          : val_d1;
				
				data    [wr_p] <= ~RS_en1 ? data_d2         : data_d1;
			
			end
			
			if (~stall & RS_en1 & RS_en2) begin
			
				v1      [wr_p + 3'b1] <= v1_d2;
				
				v2      [wr_p + 3'b1] <= v2_d2 | lw_d2;
			
				lw      [wr_p + 3'b1] <= lw_d2;
				
				sw      [wr_p + 3'b1] <= sw_d2;
				
				tag1    [wr_p + 3'b1] <= tag1_d2;
				
				tag2    [wr_p + 3'b1] <= tag2_d2;
				
				dst_tag [wr_p + 3'b1] <= dst_tag_d2;
				
				dst     [wr_p + 3'b1] <= dst_d2;
				
				imm     [wr_p + 3'b1] <= imm_d2;
				
				val     [wr_p + 3'b1] <= val_d2;
				
				data    [wr_p + 3'b1] <= data_d2;
			
			end
			
						
			for (i = 0; i < 8; i = i + 1) begin
			
				if ((tag1[i] == tag_INT1) & ~v1[i] & we_INT1) begin 
				
					val  [i] <= val_INT1;
					
					v1   [i] <= 1'b1;
					
				end
				
				if ((tag2[i] == tag_INT1) & ~v2[i] & we_INT1) begin
			
					data [i] <= val_INT1;
					
					v2   [i] <= 1'b1;
					
				end
				
				if ((tag1[i] == tag_INT2) & ~v1[i] & we_INT2) begin
			
					val  [i] <= val_INT2;
					
					v1   [i] <= 1'b1;
					
				end
				
				if ((tag2[i] == tag_INT2) & ~v2[i] & we_INT2) begin
			
					data [i] <= val_INT2;
					
					v2   [i] <= 1'b1;
					
				end
				
				if ((tag1[i] == tag_MUL) & ~v1[i] & we_MUL) begin
				
					val  [i]  <= val_MUL;
					
					v1   [i] <= 1'b1;
					
				end
				
				if ((tag2[i] == tag_MUL) & ~v2[i] & we_MUL) begin
			
					data [i]  <= val_MUL;		
					
					v2   [i]   <= 1'b1;
				
				end

				if ((tag1[i] === tag_LW) & ~v1[i] & we_LW) begin
				
					val  [i]  <= val_LW;
					
					v1   [i] <= 1'b1;
					
				end
				
				if ((tag2[i] === tag_LW) & ~v2[i] & we_LW) begin
			
					data [i]  <= val_LW;		
					
					v2   [i]   <= 1'b1;
				
				end			
			
			end
			
			
			
			
			if      (~(RS_en1 == RS_en2) & ~stall) wr_p <= wr_p + 3'b1;
			
			else if (RS_en1 & RS_en2 & ~stall)     wr_p <= wr_p + 3'd2;
			
			
			
			
			if ((v1[rd_p] & v2[rd_p]) & ~(stop & lw[rd_p])) rd_p <= rd_p + 3'b1;
						
		
		end
	
	
	end
	
	assign stall = ((wr_p + 3'd2) == rd_p) | ((wr_p + 3'b1) == rd_p);

endmodule
