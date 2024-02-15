transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/RS_INT.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/RS_MUL.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/multiplier.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/RF.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/RAT.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/ROB.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/INT_REG.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/MUL_REG.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/INST_REG.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/program_memory.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/Processor.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/Control.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/sign_ext.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/FP_RF.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/FP_RAT.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/FPU.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/RP_REG.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/RS_FP.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/RS_MEM.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/sw_buffer.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/LW_REG.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/data_mem.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/GHR.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/BTA.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/Branch_decision.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/brach_detector.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/PHT.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/BPU.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/RS_BR.v}
vlog -vlog01compat -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/BR_REG.v}

vlog -sv -work work +incdir+C:/Users/THINKPAD/Documents/FinalDesign {C:/Users/THINKPAD/Documents/FinalDesign/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
