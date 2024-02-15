module SHIFT_LIFT_BY_1BIT (
    input [31:0] data_in,
    output reg [31:0] result
);
   always @* begin
      result = data_in << 1; // Shift left by two positions
   end
endmodule
