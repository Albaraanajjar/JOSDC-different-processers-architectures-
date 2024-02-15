module mux2to1_5(in1,in2,s,out);
input [4:0] in1;
input [4:0] in2;
input s;
output [4:0] out;
assign out = in2 ? s : in1;
endmodule