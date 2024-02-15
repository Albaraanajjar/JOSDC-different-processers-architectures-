module BTA(
input [7:0] address_P1, address_P2,
input [7:0] immediate1, immediate2,
output [7:0] Targetaddress1, Targetaddress2

);


	assign Targetaddress1 = address_P1 + immediate1;
	
	assign Targetaddress2 = address_P2 + immediate2;

endmodule

