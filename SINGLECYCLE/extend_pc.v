module extend_pc(pcin,pcout);
input [7:0] pcin;
output [31:0] pcout;

assign pcout={24'b0,pcin};
endmodule