module mux2to1_32(in1,in2,s,out);
input [31:0] in1;
input [31:0] in2;
input s;
output [31:0] out;

assign out = in2 ? s : in1;
   
endmodule