`timescale 1ns/1ps
module testbench;

	reg clk, rst, DONE;
	
	integer cycles;
	
	integer instruction1, instruction2;
	
	wire [31:0] val_INT1, val_INT2, val_LW, data_C1, data_C2;
	
	wire [7:0] PC1, PC2;
	
	wire [4:0]  rd_p, wr_p, dst_tag_INT1, dst_tag_INT2, dst_tag_LW, first_tag1, first_tag2, second_tag1, second_tag2;

	wire complition, commit, flush, stall, stall_ROB, stall_MEM, stall_INT, first_v1, first_v2, second_v1, second_v2, first_r1, first_r2, second_r1, second_r2, first_forward1, second_forward1, first_forward2, second_forward2;
	
	assign instruction1 = uut.first_inst_D;
	
	assign instruction2 = uut.second_inst_D;
	
	assign PC1 = uut.PC;
	
	assign PC2 = uut.PC + 1;
	
	assign wr_p = uut.wr_p;
	
	assign val_INT1 = uut.val_INT1;
	
	assign val_INT2 = uut.val_INT2;
	
	assign val_LW   = uut.val_LW;
	
	assign data_C1  = uut.wr_data_C1;
	
	assign data_C2  = uut.wr_data_C2;
	
	assign dst_tag_INT1 = uut.dst_tag_INT1;

	assign dst_tag_INT2 = uut.dst_tag_INT2;
	
	assign dst_tag_LW    = uut.dst_tag_LW;
	
	assign first_v1 = uut.first_v1;
	
	assign first_v2 = uut.first_v2;
	
	assign second_v1 = uut.second_v1;
	
	assign second_v2 = uut.second_v2;
	
	assign first_r1 = uut.first_r1;
	
	assign first_r2 = uut.first_r2;
	
	assign second_r1 = uut.second_r1;
	
	assign second_r2 = uut.second_r2;
	
	assign rd_p = uut.rd_p;
	//assign complition_LW = uut.we_LW;
	
	assign flush = uut.flush;
	
	assign stall = uut.stall;
	
	assign stall_ROB = uut.stall_ROB;
	
	assign stall_MEM = uut.stall_MEM;
	
	assign stall_INT = uut.stall_INT;
	
	assign first_tag1 = uut.first_tag1;
	
	assign first_tag2 = uut.first_tag2;
	
	assign second_tag1 = uut.second_tag1;
	
	assign second_tag2 = uut.second_tag2;
	
	assign first_forward1 = uut.first_forward1;
	
	assign first_forward2 = uut.first_forward2;
	
	assign second_forward1 = uut.second_forward2;
	
	assign second_forward2 = uut.second_forward2;
		
	assign complition = uut.we_LW | uut.we_INT1 | uut.we_INT2 | uut.we_SW;
	
	assign commit = (~(uut.sw_en_C1 ^ uut.we_C1 ^ uut.update_signal_C1 ^ uut.update_signal_C2 ^ uut.sw_en_C2 ^ uut.we_C2) & (uut.sw_en_C1 | uut.we_C1 | uut.update_signal_C1 | uut.update_signal_C2 | uut.sw_en_C2 | uut.we_C2)) | (uut.sw_en_C1);
		
	
	initial begin : MAIN
	
		//integer i;
		
		rst  = 1'b1;
			
		#1 rst  = 1'b0;
		
		//for(i = 0; i < 1000; i = i + 1) begin
	
			#2 DONE = 1'b0;
		
			wait(uut.wr_data_C1 == 50);
			
			#2;
			
			DONE = 1'b1;
			
			#2;
			
			//$finish;
			
			
			
			
					
		//end	
	
	end
	
	//always@(posedge flush) #3 $finish;
	
	initial #2500 $finish;
	
	integer i;
	
	always@(*) cycles = i / 2 - 1;
	
	/*always@(*) begin
	
		if (uut.PC < 7) begin
	
			if (uut.PC == 0) instruction1 = "ADD";
				
			if (uut.PC == 0) instruction2 = "ADDI";
			
			if (uut.PC == 2) instruction1 = "BLT";
			
			if (uut.PC == 2) instruction2 = "ADDI";
			
			if (uut.PC == 4) instruction1 = "J";
			
			if (uut.PC == 4) instruction2 = "NOP";
			
			if (uut.PC == 5) begin
			
				instruction1 = "ADDI"; 
				
				instruction2 = "ADDI";
				
			end
			
			if (uut.PC == 7) begin
			
				instruction1 = "ADD";
				
				instruction2 = "NOP";
			
			end
		
		end
		
		else begin 
		
			instruction1 = "NOP";
			
			instruction2 = "NOP";
			
		end
			
	
	end*/
	
	
	
	Processor uut(clk, rst);

	
	initial begin
	
		clk = 1;
		
		for(i = 0; i < 6000; i = i + 1) #1 clk = ~clk;
	
	end
	
	

endmodule
