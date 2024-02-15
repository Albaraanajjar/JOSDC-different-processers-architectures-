module ALU (
    input [2:0] ALUControl,  // ALU control signals
    input [31:0] operand1,   // First operand
    input [31:0] operand2,// Second operand
	 input [4:0] shamt,
    output reg [31:0] result // ALU result
    //output reg overflow_flag // Overflow flag
);
   always @* begin
      case(ALUControl)
         3'b000: result = (operand1 & operand2); // AND
			3'b001: result = (operand1 | operand2); // OR
			3'b010: result = (operand1 + operand2); // ADD
			3'b011: result = (operand1 ^ operand2); // XOR
			3'b100: result = ~(operand1 | operand2); // NOR
         3'b101: result = (operand1 >> shamt); // SRL
			3'b110: result = (operand1 - operand2); // Subtract
			3'b111: result = (operand1 << shamt); // SLL
         //4'b1000: result = (operand1 < operand2) ? 32'b1 : 32'b0; // Set if less than
         //4'b1001: result = (operand1 < operand2) ? 32'b0 : 32'b1; // Set if greater than
			//4'b1010: result = (operand1 <= operand2) ? 32'b0 : 32'b1; //set if less than or equal 
			//4'b1011: result = (operand1 >= operand2) ? 32'b0 : 32'b1; //set if greater than or equal
         default: result = 32'b0; // Default case (no operation)
      endcase


   end
endmodule
