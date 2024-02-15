module memcovert(busin,busout);
input [31:0] busin;
output [7:0] busout;

assign busout=busin[7:0];
endmodule