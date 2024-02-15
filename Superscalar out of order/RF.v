module RF(

input clk, rst, we1, we2,
input [4:0] first_addr1, second_addr1, first_addr2, second_addr2, w_addr1, w_addr2,
input [31:0] w_data1, w_data2,

output [31:0] first_1, second_1, first_2, second_2

);


	reg [31:0] registers [31:0];
	
	
	assign first_1  = registers[first_addr1];
	
	assign second_1 = registers[second_addr1];
	
	assign first_2  = registers[first_addr2];
	
	assign second_2 = registers[second_addr2];
	
	
	always@(posedge clk, posedge rst) begin : MAIN_BLOCK
	
		integer i;
	
		if (rst) for (i = 0; i < 32; i = i + 1) registers[i] = 32'b0;
			
								
		
		else begin
		
			if (we1 & ~(w_addr1 == 5'b0) & ~(w_addr1 == w_addr2)) registers[w_addr1] <= w_data1;
			
			if (we2 & ~(w_addr2 == 5'b0))                         registers[w_addr2] <= w_data2;

		end
	
	end
    

endmodule
