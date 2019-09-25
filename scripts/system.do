onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -expand -group {Datapath Signals} -color Blue /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -expand -group {Datapath Signals} -color Blue /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -expand -group {Datapath Signals} -color Blue /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -expand -group {Datapath Signals} -color Blue /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -expand -group {Datapath Signals} -color Blue /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -expand -group {Datapath Signals} -color Blue /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -expand -group {Datapath Signals} -color Blue /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -expand -group {Datapath Signals} -color Blue /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -expand -group {Datapath Signals} -color Blue /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -expand -group {Datapath Signals} -color Blue /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -divider registers
add wave -noupdate -color Salmon /system_tb/DUT/CPU/DP/RF/reg_file
add wave -noupdate /system_tb/DUT/CPU/DP/RF/n_reg_file
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/RF/rfif/rdat2
add wave -noupdate -expand -group {FD Latch} -color {Spring Green} /system_tb/DUT/CPU/DP/fdif/imemaddr_ID
add wave -noupdate -expand -group {FD Latch} -color {Spring Green} /system_tb/DUT/CPU/DP/fdif/instr_ID
add wave -noupdate -expand -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/enable
add wave -noupdate -expand -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/halt
add wave -noupdate -expand -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/imemaddr_ID
add wave -noupdate -expand -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/busA_EX
add wave -noupdate -expand -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/busB_EX
add wave -noupdate -expand -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/ALUop
add wave -noupdate -expand -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/ALU_Src
add wave -noupdate -expand -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/PC_Src
add wave -noupdate /system_tb/DUT/CPU/DP/deif/RegWr
add wave -noupdate /system_tb/DUT/CPU/DP/DE/deif/RegWr_EX
add wave -noupdate -expand -group {EM } -color Magenta /system_tb/DUT/CPU/DP/emif/opcode_EX
add wave -noupdate -expand -group {EM } -color Magenta /system_tb/DUT/CPU/DP/emif/zero_MEM
add wave -noupdate -expand -group {EM } /system_tb/DUT/CPU/DP/EM/emif/Output_Port_MEM
add wave -noupdate -expand -group {EM } -color Magenta /system_tb/DUT/CPU/DP/emif/jump_addr
add wave -noupdate -expand -group {EM } -color Magenta /system_tb/DUT/CPU/DP/emif/branch_addr
add wave -noupdate /system_tb/DUT/CPU/DP/EM/emif/RegWr_MEM
add wave -noupdate -color Magenta /system_tb/DUT/CPU/DP/emif/Output_Port_MEM
add wave -noupdate -expand -group MW -color Aquamarine /system_tb/DUT/CPU/DP/MW/mwif/Output_Port_WB
add wave -noupdate -expand -group MW -color Aquamarine /system_tb/DUT/CPU/DP/MW/mwif/busB_WB
add wave -noupdate -expand -group MW -color Aquamarine /system_tb/DUT/CPU/DP/MW/mwif/extended_WB
add wave -noupdate -expand -group MW -color Aquamarine /system_tb/DUT/CPU/DP/MW/mwif/memtoReg_WB
add wave -noupdate -expand -group MW -color Aquamarine /system_tb/DUT/CPU/DP/MW/mwif/memWr_WB
add wave -noupdate -expand -group MW -color Aquamarine /system_tb/DUT/CPU/DP/MW/mwif/RegWr_WB
add wave -noupdate -expand -group MW /system_tb/DUT/CPU/DP/mwif/RegDst_WB
add wave -noupdate -color Cyan /system_tb/DUT/CPU/DP/MW/mwif/Output_Port_MEM
add wave -noupdate -color Cyan /system_tb/DUT/CPU/DP/MW/mwif/memtoReg_MEM
add wave -noupdate -color Cyan /system_tb/DUT/CPU/DP/MW/mwif/memWr_MEM
add wave -noupdate -color Cyan /system_tb/DUT/CPU/DP/MW/mwif/RegWr_MEM
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/iload
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/equal
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/memtoReg
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/memWr
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/ALUop
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/ALU_Src
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/EXTop
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/halt
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/PC_Src
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/RegDst
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/RegWr
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/Wsel
add wave -noupdate -group {control unit} -color Orange /system_tb/DUT/CPU/DP/CU/iREN
add wave -noupdate -group {control unit} -color Orange -expand -subitemconfig {/system_tb/DUT/CPU/DP/CU/rt.opcode {-color Orange -height 17} /system_tb/DUT/CPU/DP/CU/rt.rs {-color Orange -height 17} /system_tb/DUT/CPU/DP/CU/rt.rt {-color Orange -height 17} /system_tb/DUT/CPU/DP/CU/rt.rd {-color Orange -height 17} /system_tb/DUT/CPU/DP/CU/rt.shamt {-color Orange -height 17} /system_tb/DUT/CPU/DP/CU/rt.funct {-color Orange -height 17}} /system_tb/DUT/CPU/DP/CU/rt
add wave -noupdate /system_tb/DUT/CPU/DP/rt
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/Output_Port
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/Port_A
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/Port_B
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {429991 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {210781631650 ps} {210781724650 ps}
