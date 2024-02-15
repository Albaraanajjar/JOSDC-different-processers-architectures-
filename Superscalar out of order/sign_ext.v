module sign_ext (

input signed_D,
input [15:0] imm, 

output reg [31:0] ext_imm

);

   always @(*) begin
	
      if (~signed_D) ext_imm = {{16{imm[15]}}, imm};
			 
      else ext_imm = {16'b0, imm};
		
   end

endmodule
 

