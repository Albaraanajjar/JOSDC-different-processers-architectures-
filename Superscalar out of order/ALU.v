module ALU(
in1,
in2,
shamt,
Unsigned,
ALUcontrol,
ALUresult
);

	input [31:0] in1,in2;
	input [4:0] shamt;
	input [2:0] ALUcontrol;
	input Unsigned;
	output reg [31:0] ALUresult;
	
	wire unsigned [31:0] in1_1;
	wire unsigned [31:0] in2_1;
	
	assign in1_1=in1;
	assign in2_1=in2;
	
	always @(*)begin 
		 
				case(ALUcontrol)
					3'b000: ALUresult = ((ALUcontrol == (3'b000 | 3'b001) ) & Unsigned == 1'b1) ? in1_1+in2_1 : in1+in2;		//add,addi,addu,lw,sw
					3'b001: ALUresult = ((ALUcontrol == (3'b000 | 3'b001) ) & Unsigned == 1'b1) ? in1_1-in2_1 : in1-in2;		//sub,subu
					3'b010: ALUresult = in1&in2;		//and,andi
					3'b011: ALUresult = in1|in2;		//or,ori
					3'b100: ALUresult = in1^in2;		//xor
					3'b101: ALUresult = ~in1 & ~in2;	//nor
					3'b110: ALUresult = in1<<shamt;	//shift left
					3'b111: ALUresult = in1>>shamt;	//shift right
				endcase
			end
endmodule 

