module PIPELINE_MIPS_PROCESSOR(input MAX10_CLK1_50,
 input reset
);

	
	
	
	pll1	pll1_inst (
	.inclk0 ( MAX10_CLK1_50 ),
	.c0 ( clk )
	);


	wire clk;
	wire [31:0] instruction_out, instruction_D, ext_imm, read_data_1 ,read_data_2
	,reg_1_E,reg_2_E,sign_imm_E,alu_out,mux_3_out,mux_2_out,mux_1_out,mux_5_out,
	alu_out_M,write_data_M,data_memory_out,alu_out_W,read_data_W,DATAtoRF, branch_source_A, branch_source_B;
			
	wire reg_write_M, reg_write_W, reg_write_E, stall,
	RegWrite, RegDst, MemtoReg, MemWrite, ALUSrc,signed_D,
	mem_to_reg_E,mem_write_E,alu_src_E,reg_dst_E,mem_to_reg_W,Branch,Bne,Beq,jump,jumpR_F,prediction_F,prediction_D,zero_flag;
	
	wire [4:0] Write_reg_addr,BTA_F,BTA_E,BTA_D, next_address, write_reg_M, write_reg_W, mux_4_out, Rt_E, Rs_E, Rd_E, shamt_E, addressP1_D,addressP1_E,addressP1_M,addressP1_WB,PC_D,PC_E,ghr_F,ghr_D,ghr_E;
	
	wire [2:0] ALUcontrol, alu_control_E,branch, branch_E;
		
	wire [1:0] forward_A_E, forward_B_E;
	
	wire actual_outcome_E,actual_outcome_D,jumpR_E,BranchCompreRes, flush,update_signal_D,update_signal_E,MemRead,jumpR,prediction_E,jump_E,mem_to_reg_M,mem_write_M,jump_M,jump_W; //for comprator 
	
	reg [4:0] PC;

	
	
	always@(posedge clk, posedge reset) begin
			if(reset)
				PC = 5'b0;
			else if(~stall) begin
				if(~(actual_outcome_E == prediction_E)) begin
					PC = actual_outcome_E ? BTA_E : addressP1_E;
				end
				else if(jumpR_E) begin
					PC = reg_1_E[4:0];
				end
				else if((instruction_out[31:26]==6'b000010)) begin
					PC = instruction_out[4:0];
				end
				else if(prediction_F) begin
					PC = BTA_F;
				end
				else begin
					PC = next_address;
				end
			end
	end
		
	assign next_address = PC + 5'b1; 
	
	BPU bpu(clk,reset,next_address,instruction_out[15:0],PC,PC_E,ghr_E,instruction_out[31:26],actual_outcome_E,update_signal_E,prediction_F,BTA_F,ghr_F);//branch prediction unit

	
	INSTRUCTION_MEMORY IM (PC, ~clk, instruction_out);  //FIRST STAGE (FITCH)
		
	//------------------------------------------------------------------------
	
	INSTRUCTION_FETCH_REG IF_ID_REG (clk, reset, BTA_F, prediction_F, PC, stall, flush, instruction_out, next_address,ghr_F, instruction_D, addressP1_D,PC_D,prediction_D,BTA_D,ghr_D); //FETCH _ DECODE STAGE
	
	//------------------------------------------------------------------------
	
	CONTROL_UNIT CTRL_UNT (instruction_D[31:26],instruction_D[5:0],RegWrite,MemWrite,ALUSrc,MemRead,ALUcontrol,RegDst,MemtoReg,signed_D,branch,jump,jumpR,update_signal_D);
	
	REGISTER_FILE REG_FILE (~clk, reset, instruction_D[25:21], instruction_D[20:16], Write_reg_addr,DATAtoRF,reg_write_W,read_data_1,read_data_2); //SECOND STAGE (DECODE)
		
	SIGN_EXTENTION SIGN_EXT (instruction_D[15:0],signed_D,ext_imm);
	
	//-------------------------------------------------------------------------
	
	INSTRUCTION_DECODE_REG ID_EX (clk, reset,update_signal_D,branch,jumpR,addressP1_D,PC_D,prediction_D,BTA_D,jump,(stall|flush),RegWrite,MemtoReg,MemWrite,ALUcontrol,ALUSrc,RegDst,read_data_1,read_data_2,instruction_D[25:21],instruction_D[20:16],instruction_D[15:11],instruction_D[10:6],ext_imm,ghr_D,reg_write_E,mem_to_reg_E,mem_write_E,alu_control_E,alu_src_E,reg_dst_E,reg_1_E,reg_2_E,Rs_E,Rt_E,Rd_E,shamt_E,sign_imm_E,jump_E,addressP1_E,PC_E,prediction_E,BTA_E,jumpR_E,branch_E,update_signal_E,ghr_E); //DECODE _ EXCUTE STAGE

	//-------------------------------------------------------------------------
	
	FOUR_TO_ONE_MUX_32BIT MUX_1 (reg_1_E, alu_out_M, mux_5_out,0, forward_A_E, mux_1_out);
	
	FOUR_TO_ONE_MUX_32BIT MUX_2 (reg_2_E, alu_out_M, mux_5_out,0, forward_B_E, mux_2_out);
	 
	TWO_TO_ONE_MUX_32BIT MUX_3 (alu_src_E, mux_2_out, sign_imm_E, mux_3_out); //THIRD STAGE (EXCUTE)
	
	TWO_TO_ONE_MUX_5BIT MUX_4 (reg_dst_E, Rt_E, Rd_E, mux_4_out);
	
	ALU ALU_UNIT (alu_control_E, mux_1_out, mux_3_out, shamt_E, alu_out);
	
	Branch_decision Bd (branch_E, mux_1_out, mux_3_out, actual_outcome_E); //deciding if branch takien or not

	
		
	//--------------------------------------------------------------------------------
	
	INSTRUCTION_EXCUTE_REG IE_MEM_REG (clk, reset, jump_E, addressP1_E, reg_write_E, mem_to_reg_E,mem_write_E,alu_out,mux_2_out,mux_4_out,reg_write_M,mem_to_reg_M,mem_write_M,alu_out_M,write_data_M,write_reg_M,addressP1_M, jump_M); //EXCUTE _ MEMORY STAGE
	
	//--------------------------------------------------------------------------------
	
	DATA_MEMORY DATA_MEM (alu_out_M,~clk,write_data_M,mem_write_M,data_memory_out); // FOURTH STAGE (MEMORY)
	
	//--------------------------------------------------------------------------------
	
	MEM_WRITEBACK_REG M_W_REG (clk, reset, jump_M,addressP1_M,reg_write_M,mem_to_reg_M,data_memory_out,alu_out_M,write_reg_M,reg_write_W,mem_to_reg_W,read_data_W,alu_out_W,write_reg_W,addressP1_WB,jump_W);	// MEMORY _ WRITEBACK STAGE
	
	//---------------------------------------------------------------------------------
	
	TWO_TO_ONE_MUX_32BIT MUX_5 (mem_to_reg_W, alu_out_W, read_data_W , mux_5_out); // FIFTH STAGE (WRITE BACK)
	//this acts as a mux for address+1 and the ordinary data coming from the excute
	assign DATAtoRF = jump_W ? {27'b0, addressP1_WB} : mux_5_out;
	assign Write_reg_addr = jump_W ? 5'b11111 : write_reg_W;
	//---------------------------------------------------------------------------------
	
	HAZARD_CONTROL_UNIT HZRD_CTRL_UNT (prediction_E,actual_outcome_E,instruction_D[25:21],instruction_D[20:16],Rs_E,Rt_E,mux_4_out,mem_to_reg_E,reg_write_E,write_reg_M,mem_to_reg_M,reg_write_M,Write_reg_addr,reg_write_W,jumpR_E,
	stall,flush,forward_A_E,forward_B_E);
	
endmodule
