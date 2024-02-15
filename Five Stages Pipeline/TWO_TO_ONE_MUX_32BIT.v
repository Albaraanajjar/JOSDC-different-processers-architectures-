module TWO_TO_ONE_MUX_32BIT (
    input  sel,     // Select input (control signal)
    input  [31:0] data0,  // Data input 0
    input  [31:0] data1,  // Data input 1
    output  [31:0] mux_out  // Mux output
);

	
			assign mux_out = sel ?  data1 : data0;

	
endmodule
