module FOUR_TO_ONE_MUX_32BIT(
    input [31:0] data0, // Input 0
    input [31:0] data1, // Input 1
    input [31:0] data2, // Input 2
	 input [31:0] data3,
    input [1:0] sel, // Select lines (2 bits)
    output reg [31:0] y // Output
);

always @* begin
    case(sel)
        2'b00: y = data0;
        2'b01: y = data1;
        2'b10: y = data2;
		  2'b11: y = data3;
    endcase
end

endmodule
