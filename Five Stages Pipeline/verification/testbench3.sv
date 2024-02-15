`timescale 1ns / 1ps
module testbench3;
	
	reg clk, reset;
	
   wire [4:0] PC;
   
	wire stall, MemtoReg;
	
	wire [1:0] forward_A_E, forward_B_E;
	
   assign stall = uut.stall;
	
	assign PC = uut.PC;
	
	assign MemtoReg = uut.mem_to_reg_W;
	
	assign forward_A_E = uut.forward_A_E;
	
	assign forward_B_E = uut.forward_B_E;


	PIPELINE_MIPS_PROCESSOR uut(clk, reset);

	initial clk = 1;
	
	initial begin
		reset = 1;
		#2 reset = 0;
	end
	
	initial forever #1 clk = ~clk;
	
	initial #21 $finish;

endmodule

 
