module HAZARD_CONTROL_UNIT 
(
	input prediction,
	input actual_outcome,
	input wire [4:0] rs_D,
	input wire [4:0] rt_D,
	input wire [4:0] rs_E,
	input wire [4:0] rt_E,
	input wire [4:0] write_reg_E,
	input wire mem_to_reg_E,
	input wire reg_write_E,
	input wire [4:0] write_reg_M,
	input wire mem_to_reg_M,
	input wire reg_write_M,
	input wire [4:0] write_reg_W,
	input wire reg_write_W,
	input wire jumpR,
	//input wire branch,
	
	output  stall,
	output  flush,
	output  [1:0] forward_A_E,
	output  [1:0] forward_B_E
	//output  forward_A_D,
	//output  forward_B_D
);


		
		assign stall = (~(write_reg_E == 5'b0)) & (mem_to_reg_E) & ((write_reg_E == rs_D)|(rt_D == write_reg_E)) ;
		assign flush = ((~(prediction==actual_outcome))|jumpR) & ~stall;
		
		assign forward_A_E [0] = (~(write_reg_M == 5'b0)) & (rs_E == write_reg_M) & (reg_write_M);
		assign forward_A_E [1] = (~(write_reg_W == 5'b0)) & (rs_E == write_reg_W) & (reg_write_W) & ~((~(write_reg_M == 5'b0)) & (rs_E == write_reg_M) & (reg_write_M));
		assign forward_B_E [0] = (~(write_reg_M == 5'b0)) & (rt_E == write_reg_M) & (reg_write_M);
		assign forward_B_E [1] = (~(write_reg_W == 5'b0)) & (rt_E == write_reg_W) & (reg_write_W) & ~((~(write_reg_M == 5'b0)) & (rt_E == write_reg_M) & (reg_write_M));
	
		//assign forward_A_D  = (~(write_reg_M == 5'b0)) & (rs_D == write_reg_M) & (reg_write_M) & (~mem_to_reg_M);
		//assign forward_B_D  = (~(write_reg_M == 5'b0)) & (rt_D == write_reg_M) & (reg_write_M) & (~mem_to_reg_M);

	

endmodule	