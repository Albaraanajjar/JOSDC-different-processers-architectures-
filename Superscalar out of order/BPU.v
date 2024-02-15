module BPU(
input clk, rst,
input [7:0] next_address_F1, next_address_F2,
input [15:0] Instrimm1, Instrimm2,
input [7:0] branch_address_F1, branch_address_F2,
input [7:0] branch_address_E1, branch_address_E2,
input [4:0] ghr_E1, ghr_E2,
input [5:0] opcode1, opcode2,
input actual_outcome1, actual_outcome2,
input update_signal1, update_signal2,

output prediction1, prediction2, is_branch1, is_branch2,
output [7:0] target_address1, target_address2,
output [4:0] ghr_F
);




wire [31:0] ext_imm1,ext_imm2;


brach_detector bd
(
opcode1, opcode2,

is_branch1, is_branch2
);

 PHT pht
 (clk, rst,
 branch_address_F1, branch_address_F2,
 branch_address_E1, branch_address_E2,
 update_signal1, update_signal2, actual_outcome1, actual_outcome2,
 is_branch1, is_branch2,
 ghr_E1, ghr_E2,
 prediction1, prediction2,
 ghr_F
 );

sign_ext SIGN_EXT1 (1'b0,Instrimm1,ext_imm1);

sign_ext SIGN_EXT2 (1'b0,Instrimm2,ext_imm2);

BTA BTA_addr (next_address_F1, next_address_F2, ext_imm1[7:0], ext_imm2[7:0], target_address1, target_address2);


endmodule 
