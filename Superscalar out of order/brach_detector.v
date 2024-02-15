module brach_detector(
    input [5:0] opcode1, opcode2,
    output reg is_branch1, is_branch2
);

	localparam BEQ   = 6'b000100;
	localparam BNE   = 6'b000101;
	localparam BLT   = 6'b000110;  // New opcode for BLT
	localparam BGE   = 6'b000111;  // New opcode for BGE
	localparam BLE   = 6'b001010;  // New opcode for BLE
	localparam BGT   = 6'b001011;  // New opcode for BGT


	always @(*) begin

		 case (opcode1)
		 
			  BEQ, BNE, BLT, BGE, BLE, BGT: is_branch1 = 1'b1;
			  
			  default: is_branch1 = 1'b0;
			  
		 endcase    
		 
		 case (opcode2)
		 
			  BEQ, BNE, BLT, BGE, BLE, BGT: is_branch2 = 1'b1;
			  
			  default: is_branch2 = 1'b0;
			  
		 endcase
		 
	end

endmodule 
