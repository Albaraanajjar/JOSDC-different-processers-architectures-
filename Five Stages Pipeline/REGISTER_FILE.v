module REGISTER_FILE 
(
	 input clk,
	 input init,
    input [4:0] read_reg_1,
    input [4:0] read_reg_2,
    input [4:0] write_reg,
    input [31:0] write_data,
    input   write_enable,
    output  [31:0] read_data_1,
    output  [31:0] read_data_2
);
   reg [31:0] registers [0:31]; // Array to hold 32 registers
	

	assign read_data_1 = registers[read_reg_1];
	
   assign read_data_2 = registers[read_reg_2];
	
   always @(posedge clk) begin
	
		if(init) begin
			registers[0] = 0;
			registers[1] = 0;
			registers[2] = 0;
			registers[3] = 0;
			registers[4] = 0;
			registers[5] = 0;
			registers[6] = 0;
			registers[7] = 0;
			registers[8] = 0;
			registers[9] = 'd100;
			registers[10] = 0;
			registers[11] = 0;
			registers[12] = 0;
			registers[13] = 0;
			registers[14] = 0;
			registers[15] = 0;
			registers[16] = 0;
			registers[17] = 0;
			registers[18] = 0;
			registers[19] = 0; 
			registers[20] = 0; 
			registers[21] = 0; 
			registers[22] = 0; 
			registers[23] = 0; 
			registers[24] = 0;
			registers[25] = 0;
			registers[26] = 0;
			registers[27] = 0;
			registers[28] = 0;
			registers[29] = 0;
			registers[30] = 0;
			registers[31] = 0;
		end
      else if (write_enable)
			if(~(write_reg == (5'b0)))
				registers[write_reg] = write_data;
   end
endmodule