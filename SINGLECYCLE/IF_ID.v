module IF_ID(clk,INSTRin,PCin,PCout,INSTRout);
input [31:0] INSTRin;
input [31:0] PCin;
input clk;
output reg [31:0] PCout,INSTRout;
always @(posedge clk) begin
PCout<=PCin;
INSTRout<=INSTRin;
end
endmodule

module ID_EX(clk,immpartin,Rd,Rt,ReadData1in,ReadData2in,PCin,immpartout,Rdout,Rtout,ReadData1out,ReadData2out,PCout);
input clk;
input [31:0] PCin,immpartin,ReadData1in,ReadData2in;
input [4:0] Rd,Rt;
output reg [31:0] PCout,immpartout,ReadData1out,ReadData2out;
output reg [4:0] Rdout,Rtout;

always @(posedge clk) begin
PCout<=PCin;
immpartout<=immpartin;
ReadData1out<=ReadData1in;
ReadData2out<=ReadData2in;
Rdout<=Rd;
Rtout<=Rt;
end

endmodule 

module EX_MEM(clk,ADDresin,ALUresin,Zin,ReadData2in,MUXresin,ADDresout,ALUresout,Zout,ReadData2out,MUXresout);
input clk,Zin;
input [31:0] ADDresin,ALUresin,ReadData2in;
input [4:0] MUXresin;
output reg [31:0] ADDresout,ALUresout,ReadData2out;
output reg Zout;
output reg [4:0] MUXresout;

always @(posedge clk) begin
ADDresout<=ADDresin;
ALUresout<=ALUresin;
ReadData2out<=ReadData2in;
MUXresout<=MUXresin;
Zout<=Zin;
end

endmodule 

module MEM_WB(clk,REGdestinationin,ALUresin,MEMReadDatain,REGdesinationout,ALUresout,MEMReadDataout);
input clk;
input [4:0] REGdestinationin;
input [31:0] ALUresin,MEMReadDatain;
output reg [4:0] REGdesinationout;
output reg [31:0] ALUresout,MEMReadDataout;

always @(posedge clk) begin
ALUresout<=ALUresin;
MEMReadDataout<=MEMReadDatain;
REGdesinationout<=REGdestinationin;
end

endmodule 