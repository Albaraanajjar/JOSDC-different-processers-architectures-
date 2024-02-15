module CONTROL_UNIT (
    input [5:0] opcode,
	 input [5:0] funct,
    output reg RegWrite,
    output reg MemWrite,
    output reg ALUSrc,
    output reg MemRead,
    output reg [2:0] ALUcontrol,
    output reg RegDst,    // Register destination (Write to which register)
    output reg MemtoReg, // Memory to Register control signal
	 output reg signed_D,
	 output reg [2:0] Branch,
	 output reg jump,
	 output reg jumpR,
	 output reg update_signal
);

	initial begin
				RegWrite <= 0;
            MemWrite <= 0;
            ALUSrc <= 0;
            MemRead <= 0;
            ALUcontrol <= 3'b000; // ALU operation: Add
            RegDst <= 0;
            Branch <= 3'b000;
            MemtoReg <= 0;
				signed_D <= 0;
			   jump<=0;
				jumpR<=0;
				update_signal<=0;
				
	end
   always @(*) begin
			
		      RegWrite = 0;
            MemWrite = 0;
            ALUSrc = 0;
            //MemRead = 0;
            ALUcontrol = 3'b000; // ALU operation: Add
            RegDst = 0;
            Branch = 0;
            MemtoReg = 0;
				signed_D = 0;
				jump=0;
				jumpR=0;
				update_signal=0;
			
		case(opcode)
         6'b000000: begin // R-type instruction
            RegWrite = 1;
				RegDst = 1;
				case(funct)
					6'b100100 : ALUcontrol = 3'b000; // ALU operation: And
					6'b100101 : ALUcontrol = 3'b001; // ALU operation: or
					6'b100000 : ALUcontrol = 3'b010; // ALU operation: Add
					6'b100110 : ALUcontrol = 3'b011; // ALU operation: xor
					6'b100111 : ALUcontrol = 3'b100; // ALU operation: nor
					6'b000010 : ALUcontrol = 3'b101; // ALU operation: srl
					6'b100010 : ALUcontrol = 3'b110; // ALU operation: sub
					6'b000000 : ALUcontrol = 3'b111; // ALU operation: sll
					6'b100001 : ALUcontrol = 3'b010; // ALU operation: AddU
					6'b100011 : ALUcontrol = 3'b110; // ALU operation: subU
					6'b001000 : jumpR = 1;
					default ;

				endcase
            
         end
			6'b001100: begin // andi I-type
				RegWrite = 1;
            ALUSrc = 1;
				signed_D = 1;
			end
			6'b001101: begin // ori I-type
				RegWrite = 1;
            ALUSrc = 1;
				ALUcontrol = 3'b001; //ALU operation: or
				signed_D = 1;
			end
			6'b001000: begin //addi I-type
				RegWrite = 1;
            ALUSrc = 1;
				ALUcontrol = 3'b010; //ALU operation: add
			end
         6'b100011: begin // lw instruction
            RegWrite = 1;
            ALUSrc = 1;
            //MemRead = 1;
            ALUcontrol = 3'b010; // ALU operation: Add
            MemtoReg = 1;
         end
         6'b101011: begin // sw instruction
            MemWrite = 1;
            ALUSrc = 1;
            //MemRead = 0;
            ALUcontrol = 3'b010; // ALU operation: Add
         end
			6'b000100 : begin //beq (branch if equal) instruction
            Branch = 3'b001;
				update_signal=1;
			end
			6'b000101 : begin //bne (branch if not equal) instruction
            Branch = 3'b010;
				update_signal=1;
			end
			6'b000110 : begin //blt branch less than instruction
            Branch = 3'b011;
				update_signal=1;
			end
			6'b000111 : begin //bgt branch greater than instruction
            Branch = 3'b100;
				update_signal=1;
			end
			6'b001010 : begin //ble branch less than instruction
            Branch = 3'b101;
				update_signal=1;
			end
			6'b001011 : begin //bge branch greater than or equal instruction
            Branch = 3'b110;
				update_signal=1;
			end
			
			
			6'b000011 : begin //JAL, both are implemented exactly the same to save return address in $31, intermediate registers are edited to carry pc+4 to the write back stage
			   RegWrite = 1;
				jump=1;
			end
			

         // Add cases for other instructions as needed
         default: begin
            RegWrite = 0;
            MemWrite = 0;
            ALUSrc = 0;
            //MemRead = 0;
            ALUcontrol = 3'b000; // Default: No operation
            RegDst = 0;
            Branch = 0;
            MemtoReg = 0;
				jump=0;
				jumpR=0;
				update_signal=0;
         end
			
      endcase
   end
endmodule
