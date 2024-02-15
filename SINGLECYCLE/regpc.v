module regpc(pcin,clk,pcout);

input [31:0] pcin;
input clk;
output [7:0] pcout;
reg [7:0] pc;

always @(posedge clk) begin
pc=pcin [7:0];
end
assign pcout=pc;


endmodule