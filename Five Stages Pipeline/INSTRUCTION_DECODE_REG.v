module INSTRUCTION_DECODE_REG
(
	input wire clk,
	input wire reset,
	input wire update_siganl_D,
	input wire [2:0] branch_D,
	input wire jumpR,
	input wire [4:0] addressP1_D,
	input wire [4:0] PC_D,
	input wire prediction_D,
	input wire [4:0] BTA_D,
	input wire jump_D, 
	input wire stall,
	input wire reg_write_D,
	input wire mem_to_reg_D,
	input wire mem_write_D,
	input wire [2:0] alu_control_D,
	input wire alu_src_D,
	input wire reg_dst_D,
	input wire [31:0] reg_1_D,
	input wire [31:0] reg_2_D,
	input wire [4:0] Rs_D,
	input wire [4:0] Rt_D,
	input wire [4:0] Rd_D,
	input wire [4:0] shamt_D,
	input wire [31:0] sign_imm_D,
	input wire [4:0] ghr_D,
	
	output reg reg_write_E,
	output reg mem_to_reg_E,
	output reg mem_write_E,
	output reg [2:0] alu_control_E,
	output reg alu_src_E,
	output reg reg_dst_E,
	output reg [31:0] reg_1_E,
	output reg [31:0] reg_2_E,
	output reg [4:0] Rs_E,
	output reg [4:0] Rt_E,
	output reg [4:0] Rd_E,
	output reg [4:0] shamt_E,
	output reg [31:0] sign_imm_E,
	output reg jump_E,
	output reg [4:0] addressP1_E,
	output reg [4:0] PC_E,
	output reg prediction_E,
	output reg [4:0] BTA_E,
	output reg jumpR_E,
	output reg [2:0] branch_E,
	output reg update_siganl_E,
	output reg [4:0]ghr_E
	);

	
	always@(posedge clk, posedge reset) begin
	
		if(reset) begin
			reg_write_E = 0;
			mem_to_reg_E = 0;
			mem_write_E = 0;
			alu_control_E = 3'b000;
			alu_src_E = 0;
			reg_dst_E = 0;
			reg_1_E = 32'b0;
			reg_2_E = 32'b0;
			Rs_E = 5'b0;
			Rt_E = 5'b0;
			Rd_E = 5'b0;
			shamt_E = 5'b0;
			sign_imm_E = 32'b0;
			jump_E = 0;
			addressP1_E = 0;
			PC_E = 0;
			prediction_E = 0;
			BTA_E = 0;
			jumpR_E = 0;
			branch_E = 0;
			update_siganl_E = 0;
			ghr_E=0;
		end
		else if(stall) begin
			reg_write_E = 0;
			mem_to_reg_E = 0;
			mem_write_E = 0;
			alu_control_E = 3'b000;
			alu_src_E = 0;
			reg_dst_E = 0;
			reg_1_E = 32'b0;
			reg_2_E = 32'b0;
			Rs_E = 5'b0;
			Rt_E = 5'b0;
			Rd_E = 5'b0;
			shamt_E = 5'b0;
			sign_imm_E = 32'b0;
			jump_E = 0;
			addressP1_E = 0;
			PC_E = 0;
			prediction_E = 0;
			BTA_E = 0;
			jumpR_E = 0;
			branch_E = 0;
			update_siganl_E = 0;
			ghr_E=0;
		end
		else begin
			reg_write_E = reg_write_D;
			mem_to_reg_E = mem_to_reg_D;
			mem_write_E = mem_write_D;
			alu_control_E = alu_control_D;
			alu_src_E = alu_src_D;
			reg_dst_E = reg_dst_D;
			reg_1_E = reg_1_D;
			reg_2_E = reg_2_D;
			Rs_E = Rs_D;
			Rt_E = Rt_D;
			Rd_E = Rd_D;
			shamt_E = shamt_D;
			sign_imm_E = sign_imm_D;
			jump_E = jump_D;
			addressP1_E = addressP1_D;
			PC_E = PC_D;
			prediction_E = prediction_D;
			BTA_E = BTA_D;
			jumpR_E = jumpR;
			branch_E = branch_D;
			update_siganl_E = update_siganl_D;
			ghr_E=ghr_D;
		end
	end 
	
endmodule
