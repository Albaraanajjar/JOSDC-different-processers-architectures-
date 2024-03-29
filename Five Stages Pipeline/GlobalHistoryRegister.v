module GlobalHistoryRegister(
    input wire clock,       // Clock signal
    input wire reset,       // Reset signal
    input wire new_bit,  // Value to set in the GHR
	 input wire is_branch,
    output reg [4:0] ghr_F      // Global History Register
);
reg [4:0] ghr;

always @(negedge clock ) begin
    if (reset) begin
        // Reset the GHR to all zeros
        ghr <= 0;
    end else begin
        // Shift the GHR to the left
        if (is_branch) ghr <= {ghr[3:0], new_bit};
    end
end
always @(posedge clock) ghr_F <= ghr;

endmodule
