
module branch_detector(
    input [5:0] opcode, 
    output reg is_branch
);

localparam BEQ   = 6'b000100;
localparam BNE   = 6'b000101;
localparam BLT   = 6'b000110;  // New opcode for BLT
localparam BGE   = 6'b000111;  // New opcode for BGE
localparam BLE   = 6'b001010;  // New opcode for BLE
localparam BGT   = 6'b001011;  // New opcode for BGT


always @(*) begin
    case (opcode)
        BEQ, BNE, BLT, BGE, BLE, BGT: is_branch = 1'b1;
        default: is_branch = 1'b0;
    endcase
end

endmodule 