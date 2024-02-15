module CPU_Pipline(clk,INSTRin,PCin,PCnext);
input [31:0] INSTRin;
input [31:0] PCin;
input clk;
output [31:0] PCnext;
wire [31:0] MEMreadData,MEMwriteData,MUXresout,ADDresout,MEMaddr,PCoutF,PCoutD,PCoutEX,PCoutMEM,Immresult,PCout,ALUres,Alusecin,INSTRout,readData1,readData2,writedata,ext_imm,immpartout,ReadData1out,ReadData2out;
wire [4:0] Rdout,Rtout,Regout;
wire [2:0] aluinp;
wire zero,Zout,PCaddrsel,Branch;
//firststage
IF_ID f1(clk,INSTRin,PCin,PCout,INSTRout);
FileReg fr1(RegWrite,INSTRout[25:21],INSTRout[20:16],writereg,writedata,readData1,readData2);
SIGN_EXTENTION se(INSTRout[15:0], ext_imm);
//secondstage
ID_EX(clk,ext_imm,INSTRout[20:16],INSTRout[15:11],ReadData1,ReadData2,PCout,immpartout,Rdout,Rtout,ReadData1out,ReadData2out,PCoutD);
mux2to1_5 m215(Rdout,Rtout,RegDst,Regout);//RegDst needs to be assigned from controlunit
ALUcontrol aluc(immpartout[5:0],aluop,aluinp);//aluop needs to be assigned from control
mux2to1_32(ReadData2out,immpartout,AluSrc,Alusecin);//AluSrc needs to be assigned from control
ALUunit aluu(ReadData1out,Alusecin,aluop,ALUres,zero);
SHIFT_LIFT_BY_1BIT sl(immpartout,Immresult);
addr addr(Immresult,PCoutD,PCoutEX);
//thirdstage
EX_MEM(clk,PCoutEX,ALUres,zero,ReadData2out,Regout,ADDresout,MEMaddr,Zout,MEMwriteData,MUXresout);
assign PCaddrsel= Branch&&Zout;//Branch control signals
memfile m1(MEMaddr[7:0],clk,MEMwriteData,1,MEMwrite,MEMreadData);//MEMwrite



//
endmodule 