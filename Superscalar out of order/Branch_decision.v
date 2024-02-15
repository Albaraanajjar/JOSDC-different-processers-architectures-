module Branch_decision(
input [2:0] branch,
input [31:0] operand1, operand2,
output reg actual_outcome
);


	always @(*) begin

		case (branch)
		
			3'b001 : actual_outcome = (operand1 == operand2);
			
			3'b010 : actual_outcome = ~(operand1 == operand2);
			
			3'b011 : actual_outcome = (operand1 < operand2);
			
			3'b100 : actual_outcome = (operand1 > operand2);
			
			3'b101 : actual_outcome = (operand1 <= operand2);
			
			3'b110 : actual_outcome = (operand1 >= operand2);
			
			default  actual_outcome = 1'b0;
			
		
		endcase



	end


endmodule

