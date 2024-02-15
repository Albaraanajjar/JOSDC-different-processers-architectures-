module Control(

input [5:0] first_inst, second_inst, first_funct, second_funct,

output reg ALUsrc1, ALUsrc2, RegWrite1, RegWrite2, Unsigned1, Unsigned2, first_alu, second_alu, first_mul, second_mul, first_fp, second_fp, first_fp_op, second_fp_op, first_mem, second_mem, first_lw, second_lw, first_sw, second_sw,
output reg [2:0] ALUcontrol1, ALUcontrol2, b_cont1, b_cont2

);
	
	
	
	always @ (*) begin
	
		RegWrite1 = 1'b0;
			
		Unsigned1 = 1'b0;
			
		ALUsrc1 = 1'b0;
			
		ALUcontrol1 = 3'b000;
			
		first_mul = 1'b0;
			
		first_alu = 1'b0;
		
		first_fp  = 1'b0;
		
		first_fp_op = 1'b0;
		
		first_mem   = 1'b0;
		
		first_lw    = 1'b0;
		
		first_sw    = 1'b0;
		
		b_cont1     = 3'b0;
				
			
		RegWrite2 = 1'b0;
			
	   Unsigned2 = 1'b0;
			
		ALUsrc2 = 1'b0;
			
		ALUcontrol2 = 3'b000;
			
		second_mul = 1'b0;
			
		second_alu = 1'b0;
		
		second_fp  = 1'b0;
		
		second_fp_op = 1'b0;
		
		second_mem   = 1'b0;
		
		second_lw    = 1'b0;
		
		second_sw    = 1'b0;
		
		b_cont2     = 3'b0;
					
			
		case (first_inst)
		
			6'b000000: begin
			
			RegWrite1 = 1'b1;
						
			first_alu = ~(first_funct == 6'b011000);
			
			
				case (first_funct)
				
					6'b000000: ALUcontrol1 = 3'b110;
						
					6'b000010: ALUcontrol1 = 3'b111;
					
					6'b100000: ALUcontrol1 = 3'b000;
					
					6'b100001: begin 
					
						ALUcontrol1 = 3'b000;
					
						Unsigned1   = 1'b1;
						
					end
					
					6'b100010: ALUcontrol1 = 3'b001;
					
					6'b100011: begin
				
						ALUcontrol1 = 3'b001;
					
						Unsigned1   = 1'b1;
					
					end
					
					6'b100100: ALUcontrol1 = 3'b010;
					
					6'b100101: ALUcontrol1 = 3'b011;
					
					6'b100110: ALUcontrol1 = 3'b100;
					
					6'b100111: ALUcontrol1 = 3'b101;
					
					6'b011000: first_mul = 1'b1;
					
					default ;
					
				endcase
				
			end
			
			6'b001000: begin
			
				first_alu   = 1'b1;
							
				ALUsrc1     = 1'b1;
				
				RegWrite1   = 1'b1;
				
			end
			
			6'b001100: begin
			
			   first_alu   = 1'b1;
			
				ALUcontrol1 = 3'b010;
				
				ALUsrc1     = 1'b1;
				
				RegWrite1   = 1'b1;
				
				Unsigned1   = 1'b1;
			
			end
			
			6'b001101: begin
			
				first_alu   = 1'b1;
			
				ALUcontrol1 = 3'b011;
				
				ALUsrc1     = 1'b1;
				
				RegWrite1   = 1'b1;
				
				Unsigned1   = 1'b1;
			
			end
			
			6'h11 : begin 
			
				first_fp_op = (first_funct == 6'h1);
				
				first_fp   = 1'b1;
				
			end
			
			6'b100011: begin
			
				first_lw = 1'b1;
				
				first_mem = 1'b1;
									
				ALUsrc1 = 1'b1;
				
				RegWrite1 = 1'b1;
			
			end
			
			6'b101011: begin
			
				first_sw = 1'b1;
				
				first_mem = 1'b1;
									
				ALUsrc1 = 1'b1;
						
			end
			
			6'b000100 : b_cont1 = 3'b001;
			
			6'b000101 : b_cont1 = 3'b010;
			
			6'b000110 : b_cont1 = 3'b011;
			
			6'b000111 : b_cont1 = 3'b100;
			
			6'b001010 : b_cont1 = 3'b101;
			
			6'b001011 : b_cont1 = 3'b110;
			

			
			default ;
			
		endcase
		
		
		
		case(second_inst)
		
			6'b000000: begin
			
			RegWrite2 = 1'b1;
						
			second_alu = ~(second_funct == 6'b011000);
			
			
				case (second_funct)
				
					6'b000000: ALUcontrol2 = 3'b110;						
					
					6'b000010: ALUcontrol2 = 3'b111;
					
					6'b100000: ALUcontrol2 = 3'b000;
					
					6'b100001: begin 
					
						ALUcontrol2 = 3'b000;
					
						Unsigned2   = 1'b1;
						
					end
					
					6'b100010: ALUcontrol2 = 3'b001;
					
					6'b100011: begin
				
						ALUcontrol2 = 3'b001;
					
						Unsigned2   = 1'b1;
					
					end
					
					6'b100100: ALUcontrol2 = 3'b010;
					
					6'b100101: ALUcontrol2 = 3'b011;
					
					6'b100110: ALUcontrol2 = 3'b100;
					
					6'b100111: ALUcontrol2 = 3'b101;
					
					6'b011000: second_mul = 1'b1;
					
					default ;
					
				endcase
				
			end
			
			6'b001000: begin
			
				second_alu   = 1'b1;
							
				ALUsrc2     = 1'b1;
				
				RegWrite2   = 1'b1;
				
			end
			
			6'b001100: begin
			
				second_alu   = 1'b1;
			
				ALUcontrol2 = 3'b010;
				
				ALUsrc2     = 1'b1;
				
				RegWrite2   = 1'b1;
				
				Unsigned2   = 1'b1;
			
			end
			
			6'b001101: begin
			
				second_alu   = 1'b1;
			
				ALUcontrol2 = 3'b011;
				
				ALUsrc2     = 1'b1;
				
				RegWrite2   = 1'b1;
				
				Unsigned2   = 1'b1;
			
			end
			
			6'h11 : begin
			
				second_fp_op = (second_funct == 6'h1);
				
				second_fp    = 1'b1;
			
			end
			
			6'b100011: begin
			
				second_lw = 1'b1;
				
				second_mem = 1'b1;
									
				ALUsrc2 = 1'b1;
				
				RegWrite2 = 1'b1;
			
			end
			
			6'b101011: begin
			
				second_sw = 1'b1;
				
				second_mem = 1'b1;
									
				ALUsrc2 = 1'b1;
						
			end
			
			6'b000100 : b_cont2 = 3'b001;
			
			6'b000101 : b_cont2 = 3'b010;
			
			6'b000110 : b_cont2 = 3'b011;
			
			6'b000111 : b_cont2 = 3'b100;
			
			6'b001010 : b_cont2 = 3'b101;
			
			6'b001011 : b_cont2 = 3'b110;

			
			default ;
			
		endcase
		
	end
		
		
	
endmodule 

