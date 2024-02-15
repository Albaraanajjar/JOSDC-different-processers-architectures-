module RAT(

input clk, rst, stall, we1, we2, C_we1, C_we2, we_INT1, we_INT2, we_MUL, we_LW,
input [4:0] INT_tag1, INT_tag2, MUL_tag, LW_tag, INT_dst1, INT_dst2, MUL_dst, LW_dst, C_addr1, C_addr2, first1, first2, second1, second2, new_tag1, new_tag2, wr_addr1, wr_addr2, C_p,

output first_v1, first_v2, second_v1, second_v2, first_r1, first_r2, second_r1, second_r2,
output [4:0] first_tag1, first_tag2, second_tag1, second_tag2, dst_tag1, dst_tag2

);

	
   reg [4:0] tag [31:0];
	
	reg       v   [31:0];
	
	reg       r   [31:0];
	
	
	assign first_tag1  = tag [first1];
	
	assign second_tag1 = tag [second1];
	
	assign first_v1    = v   [first1];
	
	assign second_v1   = v   [second1];
	
	assign first_r1    = r   [first1];
	
	assign second_r1   = r   [second1];
	
	
	assign first_tag2  = tag [first2];
	
	assign second_tag2 = tag [second2];
	
	assign first_v2    = v   [first2];
	
	assign second_v2   = v   [second2];
	
	assign first_r2    = r   [first2];
	
	assign second_r2   = r   [second2];
	
	
	assign dst_tag1    = tag [wr_addr1];
	
	assign dst_tag2    = tag [wr_addr2];
	
	
	
	always@(posedge clk) begin : MAIN_BLOCK
	
		integer i;
	
		if (rst) begin
		
			for (i = 1; i < 32; i = i + 1) begin
			
				tag [i] <= 5'b0;
			
				v   [i] <= 1'b1;
				
				r   [i] <= 1'b0;
			
			end
			
			tag [0] <= 5'b0;
			
			v   [0] <= 1'b1;
				
			r   [0] <= 1'b1;
		
		end
		
		else begin
		
			if (~(wr_addr1 == 5'b0) & we1 & ~((wr_addr1 == wr_addr2) & we2) & ~stall) begin
			
				tag [wr_addr1] <= new_tag1;
				
				v   [wr_addr1] <= 1'b0;
				
				r   [wr_addr1] <= 1'b0;
			
			end
			
			if (~(wr_addr2 == 5'b0) & we2 & ~stall) begin
			
				tag [wr_addr2] <= new_tag2;
				
				v   [wr_addr2] <= 1'b0;
				
				r   [wr_addr2] <= 1'b0;
			
			end
			
			
			if (~r[INT_dst1] & (tag[INT_dst1] == INT_tag1) & ~((INT_dst1 == wr_addr1) & we1 & ~stall) & ~((INT_dst1 == wr_addr2) & we2 & ~stall) & we_INT1) r[INT_dst1] <= 1'b1;
			
			if (~r[INT_dst2] & (tag[INT_dst2] == INT_tag2) & ~((INT_dst2 == wr_addr1) & we1 & ~stall) & ~((INT_dst2 == wr_addr2) & we2 & ~stall) & we_INT2) r[INT_dst2] <= 1'b1;
			
			if (~r[MUL_dst]  & (tag[MUL_dst] == MUL_tag) & ~((MUL_dst == wr_addr1) & we1 & ~stall) & ~((MUL_dst == wr_addr2) & we2 & ~stall) & we_MUL)    r[MUL_dst]  <= 1'b1;
			
			if (~r[LW_dst]  & (tag[LW_dst] == LW_tag) & ~((LW_dst == wr_addr1) & we1 & ~stall) & ~((LW_dst == wr_addr2) & we2 & ~stall) & we_LW)        r[LW_dst]   <= 1'b1;
			
			
			
			if (r[C_addr1] & (C_p == tag[C_addr1]) & C_we1 & ~((C_addr1 == wr_addr1) & we1 & ~stall) & ~((C_addr1 == wr_addr2) & we2 & ~stall)) v[C_addr1] <= 1'b1;
				
			if (r[C_addr2] & (C_p + 5'b1 == tag[C_addr2]) & C_we2 & ~((C_addr2 == wr_addr1) & we1 & ~stall) & ~((C_addr2 == wr_addr2) & we2 & ~stall)) v[C_addr2] <= 1'b1;	
			
		
		end
	
	
	end



endmodule
