module SIGN_EXTENTION (
    input wire [15:0] imm,  // 16-bit immediate value
	 input wire signed_D,
    output reg [31:0] ext_imm  // 32-bit sign-extended immediate value
);

   always @* begin
      if (~signed_D) // If the sign bit is 0, it's positive
          ext_imm = {{16{imm[15]}}, imm}; // Extend with 16 zeros
      else // If the sign bit is 1, it's negative
          ext_imm = {16'b0, imm}; // Extend with 16 ones
   end
endmodule
