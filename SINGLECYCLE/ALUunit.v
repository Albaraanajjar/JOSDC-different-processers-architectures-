module ALUunit(a,b,aluop,res,zero);
 input [31:0] a,b;
 input [2:0] aluop;
 output reg [31:0] res;
 output zero;
  
 always @* begin
  if(aluop [2:0]==4'b000)
		res<=a&b;
  else if(aluop [2:0]==4'b001)
		res<=a|b;
  else if(aluop [2:0]==4'b010)
		res<=a+b;
  else if(aluop [2:0]==4'b110)
		res<=a-b;
  else begin 
		res[0]<=a<b;
		res[31:1]<=0;
		end
 end
 
 assign zero = 1 ? res == 0 : 0;
 

endmodule



