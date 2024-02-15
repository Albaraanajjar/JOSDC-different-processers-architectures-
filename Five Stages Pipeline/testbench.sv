`timescale 1ns / 1ps
module testbench;
	
	reg clk, reset;
	wire clk_forsample;
   wire [4:0] PC;
   
	wire stall, MemtoReg;
	
   assign stall = uut.stall;
	
	assign PC = uut.PC;
	
	assign MemtoReg = uut.mem_to_reg_W;


	PIPELINE_MIPS_PROCESSOR uut( reset);
	

	initial clk = 1;
	
	initial begin
		reset = 1;
		#2 reset = 0;
	end
	
	initial forever #1 clk = ~clk;
	
	initial #17 $finish;

endmodule

 
