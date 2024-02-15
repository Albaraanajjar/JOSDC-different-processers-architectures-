module ALUcontrol(funct,aluop,aluinp);
 input [5:0] funct;
 input [1:0] aluop;
 output reg [2:0] aluinp;
 always @* begin
 case(aluop)
 2'b00: aluinp<=3'b010;//lw,sw
 
 2'b01:aluinp<=3'b110;//beq
 2'b10: case(funct)//rest
 6'b100000:aluinp<=3'b010;
 6'b100010:aluinp<=3'b110;
 6'b100100:aluinp<=3'b000;
 6'b100101:aluinp<=3'b001;
 6'b101010:aluinp<=3'b111;
 endcase
 endcase
 end
 



endmodule

