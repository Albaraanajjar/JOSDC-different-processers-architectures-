module SIGN_EXTENTION (
    input wire [15:0] imm,  // 16-bit immediate value
    output reg [31:0] ext_imm  // 32-bit sign-extended immediate value
);

   always @* begin
      if (imm[15] == 1'b0) // If the sign bit is 0, it's positive
          ext_imm = {16'b0, imm}; // Extend with 16 zeros
      else // If the sign bit is 1, it's negative
          ext_imm = {16'b1, imm}; // Extend with 16 ones
   end
endmodule
