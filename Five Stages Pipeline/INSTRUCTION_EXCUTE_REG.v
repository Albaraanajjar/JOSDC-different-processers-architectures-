module INSTRUCTION_EXCUTE_REG
(
	input wire clk,
	input wire reset,
	input wire jump_E,
	input wire [4:0] addressP1_E,
	input wire reg_write_E,
	input wire mem_to_reg_E,
	input wire mem_write_E,
	input wire [31:0] alu_out_E,
	input wire [31:0] write_data_E,
	input wire [4:0] write_reg_E,
	output reg reg_write_M,
	output reg mem_to_reg_M,
	output reg mem_write_M,
	output reg [31:0] alu_out_M,
	output reg [31:0] write_data_M,
	output reg [4:0] write_reg_M,
	output reg [4:0] addressP1_M,
	output reg jump_M
	
);

	initial begin

	end
	
	always@(posedge clk, posedge reset) begin
		if(reset) begin
			reg_write_M <= 1'b0;
			mem_to_reg_M <= 1'b0; 
			mem_write_M <= 1'b0;
			alu_out_M <= 0;
			write_data_M <= 0;
			write_reg_M <= 5'b0;
			jump_M <= 0;
		end
		else begin
			addressP1_M=addressP1_E;
			reg_write_M = reg_write_E;
			mem_to_reg_M = mem_to_reg_E; 
			mem_write_M = mem_write_E;
			alu_out_M = alu_out_E;
			write_data_M = write_data_E;
			write_reg_M = write_reg_E;
			jump_M = jump_E;
		end
	end
endmodule
