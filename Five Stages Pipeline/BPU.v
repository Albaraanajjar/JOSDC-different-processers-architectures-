module BPU(
input clk,
input reset,
input [4:0] next_address_F,
input [15:0] Instrimm,
input [4:0] branch_address_F,
input [4:0] branch_address_E,
input [4:0] ghr_E,
input [5:0] opcode_F,
input actual_outcome,
input update_signal,

output prediction,
output [4:0] target_address_F,
output [4:0] ghr_F
);
wire is_branch;



wire [31:0] ext_imm;


branch_detector bd(opcode_F,is_branch);

PHT pht(clk,reset,branch_address_F,branch_address_E,update_signal,actual_outcome,is_branch,ghr_E,prediction,ghr_F);

SIGN_EXTENTION SIGN_EXT (Instrimm,1,ext_imm);

BTAaddr BTA_addr (next_address_F, ext_imm[4:0], target_address_F);


endmodule 