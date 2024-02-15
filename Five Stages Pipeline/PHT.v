module PHT (
input clk,
input reset,
input [4:0] InstrAddr_F,
input [4:0] InstrAddr_E,
input update_signal,
input actual_outcome,
input is_branch,
input [4:0] ghr_E,
output reg prediction,
output reg [4:0] ghr_F
); 

reg [1:0] PHtable [31:0];

integer i;

wire [4:0] ghr_F_internal;

GlobalHistoryRegister GHR(
    clk,       
    reset,       
    actual_outcome,
	 update_signal,
    ghr_F_internal);

always @* begin
    ghr_F = ghr_F_internal;
end

always @(posedge clk, posedge reset) begin  //initilize to weakly not taken
	if(reset) begin
	   for(i=0; i < 32; i = i + 1) begin
			PHtable[i] = 2'b01;
		end
	end
	else if (update_signal) begin
        // Update the PHT
        if (actual_outcome) begin
            // Branch taken increment the counter if not strongly taken
            if (~(PHtable[(ghr_E)^(InstrAddr_E)] == 2'b11))
                PHtable[(ghr_E)^(InstrAddr_E)] = PHtable[(ghr_E)^(InstrAddr_E)] + 2'b01;
        end else begin
            // Branch not taken decrement the counter if not strongly not taken
            if (~(PHtable[(ghr_E)^(InstrAddr_E)] == 2'b00))
                PHtable[(ghr_E)^(InstrAddr_E)] = PHtable[(ghr_E)^(InstrAddr_E)] - 2'b01;
        end
    end

end

always @(*) begin
    // Determine prediction only if it's a branch instruction
    if (is_branch) begin
		 case(PHtable[(ghr_F_internal)^(InstrAddr_F)])
			2'b00 : prediction=0;
			2'b01 : prediction=0;
			2'b10 : prediction=1;
			2'b11 : prediction=1;
			endcase
		end
    
	 else prediction = 0;  // Default
    
end

endmodule 