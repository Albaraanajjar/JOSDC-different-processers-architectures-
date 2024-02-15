module ControlUnit(opcode,Regdst,Alusrc,MemtoReg,Regwrite,MemRead,MemWrite,Branch,AluoP);


 input [5:0] opcode;
 output reg Regdst,Alusrc,MemtoReg,Regwrite,MemRead,MemWrite,Branch;
 output reg [1:0] AluoP;
 
 always @* begin
 case(opcode)
 6'b000000: begin
	Regdst<=1;
	Alusrc<=0;
	MemtoReg<=0;
	Regwrite<=1;
	MemRead<=0;
	MemWrite<=0;
	Branch<=0;
	AluoP=2'b10; end
 6'b100011: begin
	Regdst<=0;
	Alusrc<=1;
	MemtoReg<=1;
	Regwrite<=1;
	MemRead<=1;
	MemWrite<=0;
	Branch<=0;
	AluoP=2'b00;
	end
 6'b101011: begin
	Regdst<=0;
	Alusrc<=1;
	MemtoReg<=0;
	Regwrite<=0;
	MemRead<=0;
	MemWrite<=1;
	Branch<=0;
	AluoP<=2'b00;
	 end
 6'b000100: begin
	Regdst<=0;
	Alusrc<=0;
	MemtoReg<=0;
	Regwrite<=0;
	MemRead<=0;
	MemWrite<=0;
	Branch<=1;
	AluoP<=2'b01;
	 end
	
	endcase
	
 end




endmodule