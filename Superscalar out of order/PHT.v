module PHT (
input clk, rst,
input [7:0] InstrAddr_F1, InstrAddr_F2,
input [7:0] InstrAddr_E1, InstrAddr_E2,
input update_signal1, update_signal2,
input actual_outcome1, actual_outcome2,
input is_branch1, is_branch2,
input [4:0] ghr_E1, ghr_E2,
output prediction1, prediction2,
output [4:0] ghr_F
); 

reg [1:0] PHtable [31:0];


wire [4:0] ghr_F_internal;

GHR global_history_table(
    clk,rst,       
    actual_outcome1, actual_outcome2,
	 update_signal1, update_signal2,
    ghr_F_internal);


    assign ghr_F = ghr_F_internal;

always @(posedge clk) begin : MAIN_BLOCK

	integer i;

	if (rst) for (i = 0; i < 32; i = i + 1) PHtable[i] = 2'b01;
		
		
	
	else if (update_signal1) begin
        // Update the PHT
        if (actual_outcome1) begin
            // Branch taken increment the counter if not strongly taken
            if (~(PHtable[(ghr_E1)^(InstrAddr_E1[4:0])] == 2'b11))
                PHtable[(ghr_E1)^(InstrAddr_E1[4:0])] = PHtable[(ghr_E1)^(InstrAddr_E1[4:0])] + 2'b01;
        end else begin
            // Branch not taken decrement the counter if not strongly not taken
            if (~(PHtable[(ghr_E1)^(InstrAddr_E1[4:0])] == 2'b00))
                PHtable[(ghr_E1)^(InstrAddr_E1[4:0])] = PHtable[(ghr_E1)^(InstrAddr_E1[4:0])] - 2'b01;
        end
    end
	else if (update_signal2) begin
        // Update the PHT
        if (actual_outcome2) begin
            // Branch taken increment the counter if not strongly taken
            if (~(PHtable[(ghr_E2)^(InstrAddr_E2[4:0])] == 2'b11))
                PHtable[(ghr_E2)^(InstrAddr_E2[4:0])] = PHtable[(ghr_E2)^(InstrAddr_E2[4:0])] + 2'b01;
        end else begin
            // Branch not taken decrement the counter if not strongly not taken
            if (~(PHtable[(ghr_E2)^(InstrAddr_E2[4:0])] == 2'b00))
                PHtable[(ghr_E2)^(InstrAddr_E2[4:0])] = PHtable[(ghr_E2)^(InstrAddr_E2[4:0])] - 2'b01;
        end
    end

end

assign prediction1 = PHtable[(ghr_F_internal)^(InstrAddr_F1[4:0])][1] & is_branch1;

assign prediction2 = PHtable[(ghr_F_internal)^(InstrAddr_F2[4:0])][1] & is_branch2;


endmodule 
