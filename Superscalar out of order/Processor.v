module Processor(

input MAX10_CLK1_50, rst,

output reg [7:0] PC

);

	wire clk;
	
	pll1	pll1_inst (
	.inclk0 ( MAX10_CLK1_50 ),
	.c0 ( clk )
	);

	//reg [7:0] PC;
	
	reg we_lw, second_flush, first_forward1, second_forward1, first_forward2, second_forward2;
		
	reg [7:0] next_addr;
	
	reg [4:0] dst_tag_lw, dst_lw; 
		
	reg [31:0] first_data1, first_data2, second_data1, second_data2, first_f_data1, first_f_data2, second_f_data1, second_f_data2, first_forward_data1 , second_forward_data1, first_forward_data2, second_forward_data2;
	
	
	wire [31:0] first_inst, second_inst, first_inst_D, second_inst_D, wr_data_C1, wr_data_C2, first1, second1, first2, second2,
					val_INT1, val_INT2, val_MUL, first_ext_imm, second_ext_imm, val1_i1, val2_i2, val1_i2, val2_i1, ALUresult1, ALUresult2,
					first_data_R1, first_data_R2, second_data_R1, second_data_R2, imm_i1, imm_i2, val1_i_mul, val2_i_mul, val_mul, first_f_1, second_f_1, first_f_2, second_f_2,
					val_FP, val_f_1_i, val_f_2_i, val_fp, val_LW, val_i_mem, data_i_mem, imm_i_mem, data_m, q, data_lw, sw_b_data, mem_addr, val1_i, val2_i;
	
	wire [9:0] addr_m;
					
	
	wire [7:0] b_addr_C1, b_addr_C2, first_target_address, second_target_address, first_next_addr_D, second_next_addr_D, next_addr_BR, b_addr_BR,
	           next_addr_C1, next_addr_C2, next_addr_i, b_addr_i, first_target_address_D, second_target_address_D;
	
	wire [4:0] op_i1, op_i2, wr_addr_C1, wr_addr_C2, dst_tag_INT1, dst_tag_INT2, dst_tag_MUL, dst_INT1, dst_INT2, dst_MUL,
				  first_tag1, first_tag2, second_tag1, second_tag2, dst_tag1, dst_tag2, rd_p, dst_i1, dst_i2, tag1_i1, tag1_i2, tag2_i1, tag2_i2,
				  dst_tag_i1, dst_tag_i2, tag1_i_mul, tag2_i_mul, wr_p, dst_i_mul, dst_tag_i_mul, dst_mul, shamt_i1, shamt_i2, dst_tag_mul, dst_tag_FP, dst_FP, first_f_tag1, first_f_tag2,
				  second_f_tag1, second_f_tag2,dst_f_tag1, dst_f_tag2, dst_f_i, dst_tag_f_i, dst_fp, dst_tag_fp, dst_tag_LW, dst_tag_SW, dst_LW, dst_i_mem, dst_tag_i_mem,
				  ghr_C1, ghr_C2, ghr_F, ghr_D, ghr_BR, dst_tag_BR, ghr_i, dst_tag_i;
				  
   wire [2:0] ALUcontrol1, ALUcontrol2, b_cont1, b_cont2, b_cont_i;
	
	wire stall, ALUsrc1, ALUsrc2, RegWrite1, RegWrite2, Unsigned1, Unsigned2, first_alu, second_alu, first_mul, second_mul, we_C1, we_C2,
	     we_INT1, we_INT2, we_MUL, we_i1, we_i2, we_i_mul, false_rename1, false_rename2, first_v1, first_v2, second_v1, second_v2,
		  first_r1, first_r2, second_r1, second_r2, stall_INT, stall_ROB, stall_mul, wr_en_mul, first_nop, second_nop, nop, first_fp, second_fp,
		  first_fp_op, second_fp_op, we_f_C1, we_f_C2, we_FP, first_f_v1, second_f_v1, first_f_v2, second_f_v2, first_f_r1, second_f_r1, first_f_r2, second_f_r2,
		  false_f_rename1, false_f_rename2, we_f_i, op_f_i, stall_FP, wr_en_fp, first_mem, second_mem, first_lw, second_lw, first_sw, second_sw, we_LW,
		  we_SW,  sw_en_C1, sw_en_C2, lw_i, sw_i, sw_b, stall_SW, stall_MEM, actual_outcome_C1, actual_outcome_C2, first_branch, second_branch, first_prediction, second_prediction,
		  update_signal_C1, update_signal_C2, first_prediction_D, second_prediction_D, first_branch_D, second_branch_D, update_signal_BR, prediction_BR,
		  prediction_C1, prediction_C2, update_signal_i, prediction_i, stall_BR, actual_outcome, actual_outcome_BR, flush, jump1, jump2, inc1, sw_m;
	
	
	
	////////////////////////////////////////Fetch///////////////////////////////////////////
	
	
	always@(posedge clk) begin
	
		if (rst) PC <= 8'b11111110;
		
		else PC <= next_addr;
		
	end
	
	always@(*) begin
	
		second_flush = 1'b0;
		
	
		if (~stall | flush) begin
		
		
			//Misprediction
		
			if      (~(actual_outcome_C1 == prediction_C1)) next_addr = actual_outcome_C1 ? b_addr_C1 : next_addr_C1;
			
			else if (~(actual_outcome_C2 == prediction_C2)) next_addr = actual_outcome_C2 ? b_addr_C2 : next_addr_C2;

			//predict taken brach
			
			else if (first_prediction) begin 
			
				next_addr    = first_target_address;
				
				second_flush = 1'b1;
			
			end
			
			else if (second_prediction) next_addr = second_target_address;
			
			//jump
			
			else if (first_inst[31:26] == 6'b000010) begin
			
				next_addr = first_inst[7:0];
				
				second_flush = 1'b1;
				
			end
			
			else if (second_inst[31:26] == 6'b000010) next_addr = second_inst[7:0];
			
			// increament counter
			
			else next_addr = PC + 8'd2;
			
		end
		
		else next_addr = PC;

	
	end
	
	
	assign stall = (stall_INT & (first_alu | second_alu)) | stall_ROB | stall_mul | stall_FP | (stall_BR & (first_branch_D | second_branch_D)) | (stall_MEM & (first_mem | second_mem)) | stall_SW; // stall logic
	
	assign flush = ~(actual_outcome_C1 == prediction_C1) | ~(actual_outcome_C2 == prediction_C2); // flush logic 
	
	assign first_flush = ~(actual_outcome_C1 == prediction_C1); // flush the second insruction only
		
	assign jump1 = (first_inst_D[31:26] == 6'b000010); // jump opcode
	
	assign jump2 = (second_inst_D[31:26] == 6'b000010); // jump opcode
	
	assign nop = ~inc1 & (first_nop | second_nop | jump1 | jump2); // Nop instruction ditection 
	
	assign inc1 = jump1 ^ jump2 ^ first_nop ^ second_nop; // One instruction only
	
	assign first_nop   = (ALUsrc1 ? (first_inst_D[20:16] == 5'b0) : (first_inst_D[15:11] == 5'b0)) & RegWrite1;
	
	assign second_nop  = (ALUsrc2 ? (second_inst_D[20:16] == 5'b0) : (second_inst_D[15:11] == 5'b0)) & RegWrite2;
	
	BPU branch_prediction_unit(
	clk, rst,
	PC + 8'd1, PC + 8'd2,
	first_inst[15:0], second_inst[15:0],
	PC, PC + 8'b1,
	next_addr_C1 - 8'd2, next_addr_C2 - 8'd2,
	ghr_C1, ghr_C2,
	first_inst[31:26], second_inst[31:26],
	actual_outcome_C1, actual_outcome_C2,
	update_signal_C1, update_signal_C2,

	first_prediction, second_prediction, first_branch, second_branch,
	first_target_address, second_target_address,
	ghr_F
	);
	
	program_memory inst_mem(
	next_addr,
	next_addr + 8'b1,
	clk,
	first_inst,
	second_inst
	);
	
	
	////////////////////////////////////////////////////////////////////////////////////
	
	
	
	//////////////////////////////////Decode and rename/////////////////////////////////
	
	INST_REG instruction_buffer(

	clk, rst | flush, stall, second_flush,
	
	first_prediction, second_prediction, first_branch, second_branch,
	ghr_F,
	next_addr - 8'b1, next_addr,
	first_target_address, second_target_address,
	first_inst, second_inst,

	first_prediction_D, second_prediction_D, first_branch_D, second_branch_D,
	ghr_D,
	first_next_addr_D, second_next_addr_D,
	first_target_address_D, second_target_address_D,
	first_inst_D, second_inst_D

	);	
	
	Control CU(

	first_inst_D[31:26], second_inst_D[31:26], first_inst_D[5:0], second_inst_D[5:0],

	ALUsrc1, ALUsrc2, RegWrite1, RegWrite2, Unsigned1, Unsigned2, first_alu, second_alu, first_mul, second_mul, first_fp, second_fp, first_fp_op, second_fp_op, first_mem, second_mem, first_lw, second_lw, first_sw, second_sw,
	ALUcontrol1, ALUcontrol2, b_cont1, b_cont2

	);
		
	RF register_file(

	clk, rst, we_C1, we_C2 & ~first_flush,
	first_inst_D[25:21], second_inst_D[25:21], first_inst_D[20:16], second_inst_D[20:16], wr_addr_C1, wr_addr_C2,
	wr_data_C1, wr_data_C2,

	first1, first2, second1, second2

	);

	FP_RF floating_point_register_file(

	clk, rst, we_f_C1, we_f_C2 & ~first_flush,
	first_inst_D[20:16], second_inst_D[20:16], first_inst_D[15:11], first_inst_D[15:11], wr_addr_C1, wr_addr_C2,
	wr_data_C1, wr_data_C2,

	first_f_1, second_f_1, first_f_2, second_f_2

	);
	
	RAT register_alias_table(

	clk, rst | flush, stall, RegWrite1, RegWrite2, we_C1, we_C2, we_INT1, we_INT2, we_MUL, we_LW,
	dst_tag_INT1, dst_tag_INT2, dst_tag_MUL, dst_tag_LW, dst_INT1, dst_INT2, dst_MUL, dst_LW, wr_addr_C1, wr_addr_C2, first_inst_D[25:21], second_inst_D[25:21], first_inst_D[20:16], second_inst_D[20:16], wr_p, wr_p + 5'b1, ALUsrc1 ? first_inst_D[20:16] : first_inst_D[15:11], ALUsrc2 ? second_inst_D[20:16] : second_inst_D[15:11], rd_p,

	first_v1, first_v2, second_v1, second_v2, first_r1, first_r2, second_r1, second_r2,
	first_tag1, first_tag2, second_tag1, second_tag2, dst_tag1, dst_tag2

	);
	
   FP_RAT floating_point_register_alias_table(

	clk, rst | flush, stall, first_fp, second_fp, we_f_C1, we_f_C2, we_FP,
	dst_tag_FP, dst_FP, wr_addr_C1, wr_addr_C2, first_inst_D[20:16], second_inst_D[20:16], first_inst_D[15:11], first_inst_D[15:11], wr_p, wr_p + 5'b1, first_inst_D[10:6], second_inst_D[10:6],

	first_f_v1, first_f_v2, second_f_v1, second_f_v2, first_f_r1, first_f_r2, second_f_r1, second_f_r2,
	first_f_tag1, first_f_tag2, second_f_tag1, second_f_tag2, dst_f_tag1, dst_f_tag2

	);
	
	ROB reorder_buffer(

	clk, rst | flush, stall, we_INT1, we_INT2, we_MUL, we_FP, we_LW, we_SW, update_signal_BR, prediction_BR, actual_outcome_BR, nop | stall, inc1,
	dst_tag_INT1, dst_tag_INT2, dst_tag_MUL, dst_tag_FP, dst_tag_LW, dst_tag_SW, dst_tag_BR, dst_INT1, dst_INT2, dst_MUL, dst_FP, dst_LW, ghr_BR, first_fp ? first_f_tag1 : first_tag1, second_fp ? first_f_tag2 : first_tag2, first_fp ? second_f_tag1 : second_tag1, second_fp ? second_f_tag2 : second_tag2,
	next_addr_BR,
	b_addr_BR,
	val_INT1, val_INT2, val_MUL, val_FP, val_LW,

	we_C1, we_C2, we_f_C1, we_f_C2, sw_en_C1, sw_en_C2, update_signal_C1, update_signal_C2, prediction_C1, prediction_C2, actual_outcome_C1, actual_outcome_C2,
	wr_addr_C1, wr_addr_C2, ghr_C1, ghr_C2,
	next_addr_C1, next_addr_C2,
	b_addr_C1, b_addr_C2,
	wr_data_C1, wr_data_C2,
	
	first_data_R1, first_data_R2, second_data_R1, second_data_R2,

	wr_p, rd_p,
	stall_ROB

	);
	
	sign_ext sign_ext1(

	Unsigned1,
	first_inst_D[15:0], 

	first_ext_imm

	);
	
	sign_ext sign_ext2(

	Unsigned2,
	second_inst_D[15:0], 

	second_ext_imm

	);
	
	///////////////////////////////////false rename logic///////////////////////////
	
	assign false_rename1 = ((ALUsrc1 ? first_inst_D[20:16] : first_inst_D[15:11]) == second_inst_D[25:21]) & RegWrite1;
	
	assign false_rename2 = ((ALUsrc1 ? first_inst_D[20:16] : first_inst_D[15:11]) == second_inst_D[20:16]) & RegWrite1;
	
	assign false_f_rename1 = (first_inst_D[10:6] == second_inst_D[20:16]);
	
	assign false_f_rename2 = (first_inst_D[10:6] == second_inst_D[15:11]);
	
	////////////////////////////////////////////////////////////////////////////////
	
	
	
	//////////////////////////operands muxes for integer operations////////////////
	
	always@(*) begin
	
		if (first_v1) first_data1 = first1; else first_data1 = first_data_R1;
		
		if (first_v2) first_data2 = first2; else first_data2 = first_data_R2;
		
		if (second_v1) second_data1 = second1; else second_data1 = second_data_R1;
		
		if (second_v2) second_data2 = second2; else second_data2 = second_data_R2;

	
	end
	
	//////////////////////////////////////////////////////////////////////////////
	
	
	///////////////////////operands muxes for floating point operations///////////
	
	always@(*) begin
	
		if (first_f_v1) first_f_data1 = first_f_1; else first_f_data1 = first_data_R1;
		
		if (first_f_v2) first_f_data2 = first_f_2; else first_f_data2 = first_data_R2;
		
		if (second_f_v1) second_f_data1 = second_f_1; else second_f_data1 = second_data_R1;
		
		if (second_f_v2) second_f_data2 = second_f_2; else second_f_data2 = second_data_R2;

	
	end
	
	//////////////////////////////////////////////////////////////////////////////
	
	
	
	///////////////////////////////////forwarding logic///////////////////////////
	
	
	//.........first operand first instruction..........
	
	always@(*) begin
	
		if (we_INT1 & (dst_tag_INT1 == first_tag1)) begin
		
			first_forward1 = 1'b1;
			
			first_forward_data1 = val_INT1;
			
		end
		
		else if (we_INT2 & (dst_tag_INT2 == first_tag1)) begin
		
			first_forward1 = 1'b1;
			
			first_forward_data1 = val_INT2;
			
		end
		
		else if (we_MUL & (dst_tag_MUL == first_tag1)) begin
		
			first_forward1 = 1'b1;
			
			first_forward_data1 = val_MUL;
		
		end
		
		else if (we_LW & (dst_tag_LW == first_tag1)) begin
		
			first_forward1 = 1'b1;
			
			first_forward_data1 = val_LW;
			
		end
		
		else begin
		
			first_forward1 = 1'b0;
			
			first_forward_data1 = 32'bx;
			
		end
		
		//..................................................
		
		
		//..........second operand first instruction........
		

		if (we_INT1 & (dst_tag_INT1 == first_tag2)) begin
	
			first_forward2 = 1'b1;
			
			first_forward_data2 = val_INT1;
			
		end
		
		else if (we_INT2 & (dst_tag_INT2 == first_tag2)) begin
	
			first_forward2 = 1'b1;
			
			first_forward_data2 = val_INT2;
			
		end
		
		else if (we_MUL & (dst_tag_MUL == first_tag2)) begin
	
			first_forward2 = 1'b1;
			
			first_forward_data2 = val_MUL;
			
		end
		
		else if (we_LW & (dst_tag_LW == first_tag2)) begin
		
			first_forward2 = 1'b1;
			
			first_forward_data2 = val_LW;
			
		end
		
		else begin
		
			first_forward2 = 1'b0;
			
			first_forward_data2 = 32'bx;
			
		end
		
		//..................................................

		
		//..........first operand second instruction........		
		
		if (we_INT1 & (dst_tag_INT1 == second_tag1)) begin
		
			second_forward1 = 1'b1;
			
			second_forward_data1 = val_INT1;
			
		end
		
		else if (we_INT2 & (dst_tag_INT2 == second_tag1)) begin
		
			second_forward1 = 1'b1;
			
			second_forward_data1 = val_INT2;
			
		end
		
		else if (we_MUL & (dst_tag_MUL == second_tag1)) begin
		
			second_forward1 = 1'b1;
			
			second_forward_data1 = val_MUL;
		
		end
		
		else if (we_LW & (dst_tag_LW == second_tag1)) begin
		
			second_forward1 = 1'b1;
			
			second_forward_data1 = val_LW;
			
		end
		
		else begin
		
			second_forward1 = 1'b0;
			
			second_forward_data1 = 32'bx;
			
		end
		
		//.................................................
		
		
		//..........second operand second instruction........		

		if (we_INT1 & (dst_tag_INT1 == second_tag2)) begin
	
			second_forward2 = 1'b1;
			
			second_forward_data2 = val_INT1;
			
		end
		
		else if (we_INT2 & (dst_tag_INT2 == second_tag2)) begin
	
			second_forward2 = 1'b1;
			
			second_forward_data2 = val_INT2;
			
		end
		
		else if (we_MUL & (dst_tag_MUL == second_tag2)) begin
	
			second_forward2 = 1'b1;
			
			second_forward_data2 = val_MUL;
			
		end
		
		else if (we_LW & (dst_tag_LW == second_tag2)) begin
		
			second_forward2 = 1'b1;
			
			second_forward_data2 = val_LW;
			
		end
		
		else begin
		
			second_forward2 = 1'b0;
			
			second_forward_data2 = 32'bx;
			
		end
		
		//.................................................
		
	
	end
	
	
	/////////////////////////////////////////////////////////////////////////////////////
	
	
	/////////////////////////////////////////////////////////////////////////////////////
	
	
	
	///////////////////////////////////Integer ALU lane//////////////////////////////////
	
	RS_INT resarvation_station_integer(

	clk, rst | flush, stall, first_alu, second_alu,

	first_v1 | first_r1 | first_forward1, (first_v2 | first_r2 | first_forward2) & ~false_rename1, second_v1 | second_r1 | second_forward1, (second_v2 | second_r2 | second_forward2) & ~false_rename2,
	{ALUcontrol1, ALUsrc1, Unsigned1}, {ALUcontrol2, ALUsrc2, Unsigned2}, ALUsrc1 ? first_inst_D[20:16] : first_inst_D[15:11], ALUsrc2 ? second_inst_D[20:16] : second_inst_D[15:11], first_tag1, false_rename1 ? wr_p : first_tag2, second_tag1, false_rename2 ? wr_p : second_tag2, wr_p, inc1 ? wr_p : wr_p + 5'b1, first_inst_D[10:6], second_inst_D[10:6],
	first_ext_imm, second_ext_imm, (first_forward1 & ~first_v1 & ~first_r1) ? first_forward_data1 : first_data1, (first_forward2 & ~first_v2 & ~first_r2) ? first_forward_data2 : first_data2, (second_forward1 & ~second_v1 & ~second_r1) ? second_forward_data1 : second_data1, (second_forward2 & ~second_v2 & ~second_r2) ? second_forward_data2 : second_data2,

	we_INT1, we_INT2, we_MUL, we_LW,
	dst_tag_INT1, dst_tag_INT2, dst_tag_MUL, dst_tag_LW,
	val_INT1, val_INT2, val_MUL, val_LW,

	we_i1, we_i2,
	op_i1, op_i2, dst_i1, dst_i2, dst_tag_i1, dst_tag_i2, shamt_i1, shamt_i2,
	imm_i1, imm_i2, val1_i1, val1_i2, val2_i1, val2_i2,

	stall_INT

	);

	ALU alu1(
	
	val1_i1,
	op_i1[1] ? imm_i1 : val2_i1,
	shamt_i1,
	op_i1[0],
	op_i1[4:2],
	ALUresult1
	
	);
	
	ALU alu2(
	
	val1_i2,
	op_i2[1] ? imm_i2 : val2_i2,
	shamt_i2,
	op_i2[0],
	op_i2[4:2],
	ALUresult2
	
	);
	
	INT_REG intger_buffer1(

	clk, rst | flush, we_i1,
	dst_i1, dst_tag_i1,
	ALUresult1,

	we_INT1,
	dst_INT1, dst_tag_INT1,
	val_INT1

	);

	INT_REG intger_buffer2(

	clk, rst | flush, we_i2,
	dst_i2, dst_tag_i2,
	ALUresult2,

	we_INT2,
	dst_INT2, dst_tag_INT2,
	val_INT2

	);
	
	
	///////////////////////////////////////////////////////////////////////////////
	
	
	///////////////////////////////////Maltiplier lane/////////////////////////////
	
	RS_MUL multiplier_resarvation_station(

	clk, rst | flush, first_mul, second_mul,

	first_v1 | first_r1, (first_v2 | first_r2) & ~false_rename1, second_v1 | second_r1, (second_v2 | second_r2) & ~false_rename2,
	first_inst_D[15:11], second_inst_D[15:11], first_tag1, false_rename1 ? wr_p : first_tag2, second_tag1, false_rename2 ? wr_p : second_tag2, wr_p, wr_p + 5'b1,
	first_data1, first_data2, second_data1, second_data2,

	we_INT1, we_INT2, we_MUL, we_LW,
	dst_tag_INT1, dst_tag_INT2, dst_tag_MUL, dst_tag_LW,
	val_INT1, val_INT2, val_MUL, val_LW,
	
	we_i_mul,
	dst_i_mul, dst_tag_i_mul,
	val1_i_mul, val2_i_mul,

	stall_mul

	);
	
	multiplier mul(

	clk,
	rst | flush,
	val1_i_mul,
	val2_i_mul,
	dst_tag_i_mul,
	dst_i_mul,
	we_i_mul,

	val_mul,
	dst_tag_mul,
	dst_mul,
	wr_en_mul

	);
	
	MUL_REG multiplier_buffer(

	clk, rst | flush, wr_en_mul,
	dst_mul, dst_tag_mul,
	val_mul,

	we_MUL,
	dst_MUL, dst_tag_MUL,
	val_MUL

	);
	
	/////////////////////////////////////////////////////////////////////////////
	
	
	//////////////////////////Floating point ALU lane////////////////////////////
	
	RS_FP floating_point_resarvation_station(

	clk, rst | flush, first_fp, second_fp,

	first_fp_op, second_fp_op, first_f_v1 | first_f_r1, (first_f_v2 | first_f_r2) & ~false_f_rename1, second_f_v1 | second_f_r1, (second_f_v2 | second_f_r2) & ~false_f_rename2,
	first_inst_D[10:6], second_inst_D[10:6], first_f_tag1, false_f_rename1 ? wr_p : first_f_tag2, second_f_tag1, false_f_rename2 ? wr_p : second_f_tag2, wr_p, wr_p + 5'b1,
	first_f_data1, first_f_data2, second_f_data1, second_f_data2,

	we_FP,
	dst_tag_FP,
	val_FP,

	we_f_i, op_f_i,
	dst_f_i, dst_tag_f_i,
	val_f_1_i, val_f_2_i,
	stall_FP

	);
		
	FPU floating_point_unit(

	clk, rst | flush,
	op_f_i, we_f_i,
	dst_tag_f_i, dst_f_i,
	val_f_1_i, val_f_2_i,

	wr_en_fp,
	dst_fp, dst_tag_fp,
	val_fp

	);
	
	RP_REG floating_point_register(

	clk, rst | flush, wr_en_fp,
	dst_fp, dst_tag_fp,
	val_fp,

	we_FP,
	dst_FP, dst_tag_FP,
	val_FP

	);
	
	/////////////////////////////////////////////////////////////////////////////////////
	
	
	/////////////////////////////////////Memory lane/////////////////////////////////////
	
	RS_MEM memory_reservation_station(

	clk, rst | flush, first_mem, second_mem, (sw_en_C1 | (sw_en_C2 & ~first_flush &  (we_C1 | we_C1 | update_signal_C1))),

	first_v1 | first_r1 | first_forward1, (first_v2 | first_r2 | first_forward2) & ~false_rename1, second_v1 | second_r1 | second_forward1, (second_v2 | second_r2 | second_forward2) & ~false_rename2, first_lw, second_lw, first_sw, second_sw,
	first_inst_D[20:16], second_inst_D[20:16], first_tag1, false_rename1 ? wr_p : first_tag2, second_tag1, false_rename2 ? wr_p : second_tag2, wr_p, wr_p + 5'b1,
	first_ext_imm, second_ext_imm, (first_forward1 & ~first_v1 & ~first_r1) ? first_forward_data1 : first_data1, (first_forward2 & ~first_v2 & ~first_r2) ? first_forward_data2 : first_data2, (second_forward1 & ~second_v1 & ~second_r1) ? second_forward_data1 : second_data1, (second_forward2 & ~second_v2 & ~second_r2) ? second_forward_data2 : second_data2,

	we_INT1, we_INT2, we_MUL, we_LW,
	dst_tag_INT1, dst_tag_INT2, dst_tag_MUL, dst_tag_LW,
	val_INT1, val_INT2, val_MUL, val_LW,

	lw_i, sw_i,
	dst_i_mem, dst_tag_i_mem,
	imm_i_mem, val_i_mem, data_i_mem,
	stall_MEM

	);
	
	assign mem_addr = val_i_mem + imm_i_mem; // address unit
	
	assign dst_tag_SW = dst_tag_i_mem;
	
	assign we_SW = sw_i;
	
	sw_buffer store_buffer(

	clk, rst | flush,(sw_en_C1 | (sw_en_C2 & ~first_flush &  (we_C1 | we_C1 | update_signal_C1))), sw_i,
	mem_addr[9:0],
	data_i_mem,
	
	sw_b,
	sw_b_data,

	sw_m,
	addr_m,
	data_m,
	stall_SW

	);
	
   data_mem Data_Memory(
	(sw_en_C1 | (sw_en_C2 & ~first_flush & (we_C1 | we_C1 | update_signal_C1))) ? addr_m : mem_addr[9:0],
	clk,
	data_m,
	lw_i,
	(sw_en_C1 | (sw_en_C2 & ~first_flush &  (we_C1 | we_C1 | update_signal_C1))),
	q
	);
	
	assign data_lw = sw_b ? sw_b_data : q;
	
	
	// Intermediate registers in the memory lane
	
	always@(posedge clk) begin
	
		if (rst | sw_en_C1 | sw_en_C2 | flush) begin
		
			we_lw      <= 1'b0;
			
			dst_lw     <= 5'b0;
			
			dst_tag_lw <= 5'b0;
					
		end
		
		else begin
		
			we_lw      <= lw_i;
			
			dst_lw     <= dst_i_mem;
			
			dst_tag_lw <= dst_tag_i_mem;
			
		end
	
	
	end

	LW_REG load_register(

	clk, rst | flush , we_lw,
	dst_lw, dst_tag_lw,
	data_lw,

	we_LW,
	dst_LW, dst_tag_LW,
	val_LW

	);
	
	///////////////////////////////////////////////////////////////////////////////////
	
	
	///////////////////////////////Branch prediction///////////////////////////////////
	
	RS_BR branch_reservation_station(

	clk, rst | flush, stall, first_branch_D, second_branch_D,

	first_v1 | first_r1 | first_forward1, (first_v2 | first_r2 | first_forward2) & ~false_rename1, second_v1 | second_r1 | second_forward1, (second_v2 | second_r2 | second_forward2) & ~false_rename2, first_prediction_D, second_prediction_D,
	b_cont1, b_cont2,
	ghr_D, ghr_D, first_tag1, false_rename1 ? wr_p : first_tag2, second_tag1, false_rename2 ? wr_p : second_tag2, wr_p, wr_p + 5'b1,
	first_next_addr_D, second_next_addr_D,
	first_target_address_D, second_target_address_D,
   (first_forward1 & ~first_v1 & ~first_r1) ? first_forward_data1 : first_data1, (first_forward2 & ~first_v2 & ~first_r2) ? first_forward_data2 : first_data2, (second_forward1 & ~second_v1 & ~second_r1) ? second_forward_data1 : second_data1, (second_forward2 & ~second_v2 & ~second_r2) ? second_forward_data2 : second_data2,
	we_INT1, we_INT2, we_MUL, we_LW,
	dst_tag_INT1, dst_tag_INT2, dst_tag_MUL, dst_tag_LW,
	val_INT1, val_INT2, val_MUL, val_LW,

	update_signal_i, prediction_i,
	b_cont_i,
	ghr_i, dst_tag_i,
	next_addr_i,
	b_addr_i,
	val1_i, val2_i,
	stall_BR

	);
	
	Branch_decision branch_decision(
	b_cont_i,
	val1_i, val2_i,
	actual_outcome
	);
	
	BR_REG branch_register(

	clk, rst | flush, update_signal_i, prediction_i, actual_outcome,
	ghr_i, dst_tag_i,
	next_addr_i,
	b_addr_i,

   update_signal_BR, prediction_BR, actual_outcome_BR,
	ghr_BR, dst_tag_BR,
	next_addr_BR,
	b_addr_BR
	);
	
	
	///////////////////////////////////////////////////////////////////////////////////////
	
	

endmodule
