module FileReg(RegWrite,readreg1,readreg2,writereg,writedata,readData1,readData2);
input RegWrite;
input [4:0] readreg1;
input [4:0] readreg2;
input [4:0] writereg;
input [31:0] writedata;
output reg [31:0] readData1;
output reg [31:0] readData2;
reg [31:0] registers [31:0];
always @* begin

readData1<=registers[readreg1];
readData2<=registers[readreg2];
if(RegWrite)
registers[writereg]<=writedata;

end
endmodule