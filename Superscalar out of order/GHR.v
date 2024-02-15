module GHR(
    input wire clock,       // Clock signal
    input wire reset,       // Reset signal
    input wire new_bit1, new_bit2,  // Value to set in the GHR
	 input wire is_branch1, is_branch2,
    output reg [4:0] ghr_F      // Global History Register
);
reg [4:0] ghr;

always @(posedge clock, posedge reset) begin
    if (reset) begin
        // Reset the GHR to all zeros
        ghr <= 5'b0;
    end else begin
        // Shift the GHR to the left
        if (is_branch1 & is_branch2) ghr <= {ghr[2:0], new_bit1, new_bit2};
		  else if (is_branch1 ^ is_branch2) ghr <= {ghr[3:0], is_branch1 ? new_bit1: new_bit2};
    end
end

always @(posedge clock) ghr_F <= ghr;

endmodule
