module multiplier(

input clk,
input reset,
input [31:0] A,
input [31:0] B,
input [4:0] dst_tag,
input [4:0] dst,
input wr_en,

output [31:0] result,
output [4:0] dst_tag_mul,
output [4:0] dst_mul,
output wr_en_mul

);

	reg [31:0] first [31:0];
	
	reg [4:0] dst_tag_first;
	
	reg [4:0] dst_first;
	
	reg wr_en_first;
	
	reg [31:0] second [15:0];
	
	reg [4:0] dst_tag_second;
	
	reg [4:0] dst_second;
	
	reg wr_en_second;
	
	reg [31:0] third [7:0];

	reg [4:0] dst_tag_third;
	
	reg [4:0] dst_third;
	
	reg wr_en_third;	

	reg [31:0] forth [3:0];
	
	reg [4:0] dst_tag_forth;
	
	reg [4:0] dst_forth;
	
	reg wr_en_forth;
	
	reg [31:0] fifth [1:0];
	
	reg [4:0] dst_tag_fifth;
	
	reg [4:0] dst_fifth;
	
	reg wr_en_fifth;
		
	
	always@(posedge clk) begin : mul
	
		integer i;
	
		if (reset) begin
		
			for (i = 0; i < 32; i = i + 1) first[i] <= 0;
			
			dst_tag_first <= 5'b0;
	
			dst_first <= 5'b0;
	
			wr_en_first <= 1'b0;
			
			for (i = 0; i < 16; i = i + 1) second[i] <= 0;

			dst_tag_second <= 5'b0;
	
			dst_second <= 5'b0;
	
			wr_en_second <= 1'b0;
			
			for (i = 0; i < 8; i = i + 1) third[i] <= 0;
			
			dst_tag_third <= 5'b0;
	
			dst_third <= 5'b0;
	
			wr_en_third <= 1'b0;
			
			for (i = 0; i < 4; i = i + 1) forth[i] <= 0;
		
			dst_tag_forth <= 5'b0;
	
			dst_forth <= 5'b0;
	
			wr_en_forth <= 1'b0;
			
			for (i = 0; i < 2; i = i + 1) fifth[i] <= 0;
			
			dst_tag_fifth <= 5'b0;
	
			dst_fifth <= 5'b0;
	
			wr_en_fifth <= 1'b0;
			
		end
		
		else begin
		
			for (i = 0; i < 32; i = i + 1) first[i] <= ({32{B[i]}} & A) << i;
			
			dst_tag_first <= dst_tag;
	
			dst_first <= dst;
	
			wr_en_first <= wr_en;
			
			for (i = 0; i < 16; i = i + 1) second[i] <= first[2 * i] + first[2 * i+ 1];
			
			dst_tag_second <= dst_tag_first;
	
			dst_second <= dst_first;
	
			wr_en_second <= wr_en_first;
			
			for (i = 0; i < 8; i = i + 1) third[i] <= second[2 * i] + second[2 * i + 1];
			
			dst_tag_third <= dst_tag_second;
	
			dst_third <= dst_second;
	
			wr_en_third <= wr_en_second;
			
			for (i = 0; i < 4; i = i + 1) forth[i] <= third[2 * i] + third[2 * i + 1];
			
			dst_tag_forth <= dst_tag_third;
	
			dst_forth <= dst_third;
	
			wr_en_forth <= wr_en_third;			
			
			for (i = 0; i < 2; i = i + 1) fifth[i] <= forth[2 * i] + forth[2 * i + 1];
			
			dst_tag_fifth <= dst_tag_forth;
	
			dst_fifth <= dst_forth;
	
			wr_en_fifth <= wr_en_forth;			
			
			
		end
	
	end
	
	assign result = fifth[0] + fifth[1];
	
	assign dst_tag_mul = dst_tag_fifth;
	
	assign dst_mul = dst_fifth;
	
	assign wr_en_mul = wr_en_fifth;


endmodule

