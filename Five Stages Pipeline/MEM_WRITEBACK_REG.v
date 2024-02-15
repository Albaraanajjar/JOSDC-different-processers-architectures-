module MEM_WRITEBACK_REG
(
	input wire clk,
	input wire reset,
	input wire jump_M,
	input wire [4:0] addressP1_M,
	input wire reg_write_M,
	input wire mem_to_reg_M,
	input wire [31:0] data_mem_out,
	input wire [31:0] alu_out_M,
	input wire [4:0] write_reg_M,
	
	output reg reg_write_W,
	output reg mem_to_reg_W,
	output reg [31:0] read_data_W,
	output reg [31:0] alu_out_W,
	output reg [4:0] write_reg_W,
	output reg [4:0] addressP1_WB,
	output reg jump_W
);

	
	always@(posedge clk, posedge reset) begin
		if(reset) begin
			reg_write_W <= 1'b0; 
			mem_to_reg_W <= 1'b0;
			read_data_W <= 0;
			alu_out_W <= 0;
			write_reg_W <= 5'b0;
			jump_W <= 0;
		end
		else begin
			addressP1_WB <= addressP1_M;
			reg_write_W <= reg_write_M; 
			mem_to_reg_W <= mem_to_reg_M;
			read_data_W <= data_mem_out;
			alu_out_W <= alu_out_M;
			write_reg_W <= write_reg_M;
			jump_W <= jump_M;
		end
	end
	
endmodule
