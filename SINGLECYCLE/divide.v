module divide(IR,data_31_26,data_25_21,data_20_16,data_15_11,data_15_0,data_5_0);
input [31:0] IR;
output [31:26] data_31_26;
output [25:21] data_25_21;
output [20:16] data_20_16;
output [15:11] data_15_11;
output [15:0] data_15_0;
output [5:0] data_5_0;

assign data_25_21=IR [25:21];
assign data_20_16=IR [20:16];
assign data_15_11=IR [15:11];
assign data_15_0=IR [15:0];
assign data_5_0= IR [5:0];
endmodule