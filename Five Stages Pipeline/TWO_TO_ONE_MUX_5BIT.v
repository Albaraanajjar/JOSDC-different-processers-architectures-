module TWO_TO_ONE_MUX_5BIT (
    input  sel,     // Select input (control signal)
    input  [4:0] data0,  // Data input 0
    input  [4:0] data1,  // Data input 1
    output  [4:0] mux_out  // Mux output
);

	
			assign mux_out = sel ?  data1 : data0;

	
endmodule