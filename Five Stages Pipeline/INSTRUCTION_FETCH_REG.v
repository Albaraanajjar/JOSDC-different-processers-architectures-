module INSTRUCTION_FETCH_REG
(
	input clk,
	input reset,
	input [4:0] BTA_F,
	input prediction_F,
	input [4:0] PC_F,
	input stall,
	input flush,
	input wire [31:0] instruction_F,
	input wire [4:0] next_address_F,
	input wire [4:0] ghr_F,
	output reg [31:0] instruction_D,
	output reg [4:0] next_address_D,
	output reg [4:0] PC_D,
	output reg prediction_D,
	output reg [4:0] BTA_D,
	output reg [4:0] ghr_D
);

	
	always @ (posedge clk, posedge reset) begin
		if(reset) begin
			instruction_D <= 0;
			BTA_D <= 0;
			prediction_D <= 0;
			next_address_D <= 0;
			PC_D <= 0;
			ghr_D<=0;
		end
		else if (flush) begin
			instruction_D = 0;
			BTA_D = 0;
			prediction_D = 0;
			next_address_D = 0;
			PC_D = 0;
			ghr_D=0;
		end
		else if (~stall) begin
			prediction_D = prediction_F;
			instruction_D = instruction_F;
			next_address_D = next_address_F;
			PC_D = PC_F;
			BTA_D = BTA_F;
			ghr_D=ghr_F;
		end
	end

endmodule
