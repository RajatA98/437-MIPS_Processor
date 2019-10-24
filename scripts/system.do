onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -radix decimal /system_tb/DUT/CPU/CM/DCACHE/hit_count
add wave -noupdate -expand -group fdif /system_tb/DUT/CPU/DP/FD/fdif/flush
add wave -noupdate -expand -group fdif /system_tb/DUT/CPU/DP/fdif/enable
add wave -noupdate -expand -group deif /system_tb/DUT/CPU/DP/DE/deif/flush
add wave -noupdate -expand -group deif /system_tb/DUT/CPU/DP/deif/enable
add wave -noupdate -expand -group emif /system_tb/DUT/CPU/DP/EM/emif/flush
add wave -noupdate -expand -group emif /system_tb/DUT/CPU/DP/emif/enable
add wave -noupdate -expand -group mwif /system_tb/DUT/CPU/DP/MW/mwif/flush
add wave -noupdate -expand -group mwif /system_tb/DUT/CPU/DP/mwif/enable
add wave -noupdate -expand -group {requests to memory} -color Plum /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate -expand -group {requests to memory} -color Plum /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate -expand -group {requests to memory} -color Plum /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate -expand -group {Datapath Signals} -color Cyan /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -expand -group {Datapath Signals} -color Magenta /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -expand -group {Datapath Signals} -color {Orange Red} /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -expand -group {Datapath Signals} /system_tb/DUT/CPU/CM/DCACHE/miss_cnt
add wave -noupdate -expand -group {Datapath Signals} -color {Orange Red} /system_tb/DUT/CPU/CM/DCACHE/dcache_state
add wave -noupdate -expand -group {Datapath Signals} -color Cyan /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -expand -group {Datapath Signals} -color Cyan /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -expand -group {Datapath Signals} -color Cyan /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -expand -group {Datapath Signals} -color Cyan /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -expand -group {Datapath Signals} -color Cyan /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -expand -group {Datapath Signals} -color Cyan /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -expand -group {Datapath Signals} -color Cyan /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -expand -group {Datapath Signals} -color Cyan -radix hexadecimal /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -divider registers
add wave -noupdate -color Salmon -expand -subitemconfig {{/system_tb/DUT/CPU/DP/RF/reg_file[31]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[30]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[29]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[28]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[27]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[26]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[25]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[24]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[23]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[22]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[21]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[20]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[19]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[18]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[17]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[16]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[15]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[14]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[13]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[12]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[11]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[10]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[9]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[8]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[7]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[6]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[5]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[4]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[3]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[2]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[1]} {-color Salmon} {/system_tb/DUT/CPU/DP/RF/reg_file[0]} {-color Salmon}} /system_tb/DUT/CPU/DP/RF/reg_file
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
add wave -noupdate /system_tb/DUT/CPU/DP/fdif/flush
add wave -noupdate /system_tb/DUT/CPU/DP/fdif/enable
add wave -noupdate -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/enable
add wave -noupdate -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/halt
add wave -noupdate -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/imemaddr_ID
add wave -noupdate -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/busA_EX
add wave -noupdate -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/busB_EX
add wave -noupdate -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/ALUop
add wave -noupdate -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/ALU_Src
add wave -noupdate -group {DE Latch} -color Gold /system_tb/DUT/CPU/DP/deif/PC_Src
add wave -noupdate /system_tb/DUT/CPU/DP/deif/instr_EX
add wave -noupdate /system_tb/DUT/CPU/DP/deif/RegWr
add wave -noupdate /system_tb/DUT/CPU/DP/DE/deif/RegWr_EX
add wave -noupdate -expand -group {EM } -color Magenta /system_tb/DUT/CPU/DP/emif/opcode_EX
add wave -noupdate -expand -group {EM } -color Magenta /system_tb/DUT/CPU/DP/emif/zero_MEM
add wave -noupdate -expand -group {EM } /system_tb/DUT/CPU/DP/EM/emif/Output_Port_MEM
add wave -noupdate -expand -group {EM } -color Magenta /system_tb/DUT/CPU/DP/emif/jump_addr
add wave -noupdate -expand -group {EM } -color Magenta /system_tb/DUT/CPU/DP/emif/branch_addr
add wave -noupdate /system_tb/DUT/CPU/DP/emif/memWr_MEM
add wave -noupdate /system_tb/DUT/CPU/DP/EM/emif/instr_MEM
add wave -noupdate /system_tb/DUT/CPU/DP/EM/emif/imemaddr_MEM
add wave -noupdate /system_tb/DUT/CPU/DP/EM/emif/RegWr_MEM
add wave -noupdate -color Magenta /system_tb/DUT/CPU/DP/emif/Output_Port_MEM
add wave -noupdate -group MW -color Aquamarine /system_tb/DUT/CPU/DP/MW/mwif/Output_Port_WB
add wave -noupdate -group MW -color Aquamarine /system_tb/DUT/CPU/DP/MW/mwif/busB_WB
add wave -noupdate -group MW -color Aquamarine /system_tb/DUT/CPU/DP/MW/mwif/extended_WB
add wave -noupdate -group MW -color Aquamarine /system_tb/DUT/CPU/DP/MW/mwif/memtoReg_WB
add wave -noupdate -group MW -color Aquamarine /system_tb/DUT/CPU/DP/MW/mwif/memWr_WB
add wave -noupdate -group MW -color Aquamarine /system_tb/DUT/CPU/DP/MW/mwif/RegWr_WB
add wave -noupdate -group MW /system_tb/DUT/CPU/DP/mwif/RegDst_WB
add wave -noupdate /system_tb/DUT/CPU/DP/mwif/instr_WB
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
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/instr_ID
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/instr_EX
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/instr_MEM
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/flush_ID
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/enable_ID
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/flush_EX
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/enable_EX
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/flush_MEM
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/enable_MEM
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/RegWr_EX
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/memWr_EX
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/RegWr_MEM
add wave -noupdate -expand -group {Hazard Unit} /system_tb/DUT/CPU/DP/HU/memWr_MEM
add wave -noupdate -expand -group {Hazard Unit} -expand -group rtype -radix unsigned -childformat {{/system_tb/DUT/CPU/DP/HU/rt_ID.opcode -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_ID.rs -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_ID.rt -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_ID.rd -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_ID.shamt -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_ID.funct -radix unsigned}} -expand -subitemconfig {/system_tb/DUT/CPU/DP/HU/rt_ID.opcode {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_ID.rs {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_ID.rt {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_ID.rd {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_ID.shamt {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_ID.funct {-height 17 -radix unsigned}} /system_tb/DUT/CPU/DP/HU/rt_ID
add wave -noupdate -expand -group {Hazard Unit} -expand -group rtype -radix unsigned -childformat {{/system_tb/DUT/CPU/DP/HU/rt_EX.opcode -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_EX.rs -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_EX.rt -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_EX.rd -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_EX.shamt -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_EX.funct -radix unsigned}} -expand -subitemconfig {/system_tb/DUT/CPU/DP/HU/rt_EX.opcode {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_EX.rs {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_EX.rt {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_EX.rd {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_EX.shamt {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_EX.funct {-height 17 -radix unsigned}} /system_tb/DUT/CPU/DP/HU/rt_EX
add wave -noupdate -expand -group {Hazard Unit} -expand -group rtype -radix unsigned -childformat {{/system_tb/DUT/CPU/DP/HU/rt_MEM.opcode -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_MEM.rs -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_MEM.rt -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_MEM.rd -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_MEM.shamt -radix unsigned} {/system_tb/DUT/CPU/DP/HU/rt_MEM.funct -radix unsigned}} -expand -subitemconfig {/system_tb/DUT/CPU/DP/HU/rt_MEM.opcode {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_MEM.rs {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_MEM.rt {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_MEM.rd {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_MEM.shamt {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/rt_MEM.funct {-height 17 -radix unsigned}} /system_tb/DUT/CPU/DP/HU/rt_MEM
add wave -noupdate -expand -group {Hazard Unit} -group itype -radix unsigned -childformat {{/system_tb/DUT/CPU/DP/HU/it_ID.opcode -radix unsigned} {/system_tb/DUT/CPU/DP/HU/it_ID.rs -radix unsigned} {/system_tb/DUT/CPU/DP/HU/it_ID.rt -radix unsigned} {/system_tb/DUT/CPU/DP/HU/it_ID.imm -radix unsigned}} -expand -subitemconfig {/system_tb/DUT/CPU/DP/HU/it_ID.opcode {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/it_ID.rs {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/it_ID.rt {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/it_ID.imm {-height 17 -radix unsigned}} /system_tb/DUT/CPU/DP/HU/it_ID
add wave -noupdate -expand -group {Hazard Unit} -group itype -radix unsigned -childformat {{/system_tb/DUT/CPU/DP/HU/it_EX.opcode -radix unsigned} {/system_tb/DUT/CPU/DP/HU/it_EX.rs -radix unsigned} {/system_tb/DUT/CPU/DP/HU/it_EX.rt -radix unsigned} {/system_tb/DUT/CPU/DP/HU/it_EX.imm -radix unsigned}} -expand -subitemconfig {/system_tb/DUT/CPU/DP/HU/it_EX.opcode {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/it_EX.rs {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/it_EX.rt {-height 17 -radix unsigned} /system_tb/DUT/CPU/DP/HU/it_EX.imm {-height 17 -radix unsigned}} /system_tb/DUT/CPU/DP/HU/it_EX
add wave -noupdate -expand -group {Hazard Unit} -group itype -radix unsigned /system_tb/DUT/CPU/DP/HU/it_MEM
add wave -noupdate /system_tb/DUT/CPU/DP/fdif/next_addr
add wave -noupdate /system_tb/DUT/CPU/DP/emif/branch_addr_MEM
add wave -noupdate /system_tb/DUT/CPU/DP/emif/jump_addr_MEM
add wave -noupdate /system_tb/DUT/CPU/DP/branch_addr
add wave -noupdate /system_tb/DUT/CPU/DP/CU/equal
add wave -noupdate /system_tb/DUT/CPU/DP/CU/PC_Src
add wave -noupdate /system_tb/DUT/CPU/DP/deif/PC_Src_EX
add wave -noupdate /system_tb/DUT/CPU/DP/emif/PC_Src_MEM
add wave -noupdate /system_tb/DUT/CPU/DP/pc_halt
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/instr_EX
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/instr_MEM
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/instr_WB
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/RegWr_MEM
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/memWr_MEM
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/memtoReg_MEM
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/RegWr_WB
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/memtoReg_WB
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/Asel
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/Bsel
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/rt_EX
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/rt_MEM
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/rt_WB
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/it_EX
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/it_MEM
add wave -noupdate -expand -group FU /system_tb/DUT/CPU/DP/FU/it_WB
add wave -noupdate /system_tb/DUT/CPU/DP/fw_enable
add wave -noupdate /system_tb/DUT/CPU/DP/hazard_enable
add wave -noupdate /system_tb/DUT/CPU/DP/hazard_detect
add wave -noupdate /system_tb/DUT/CPU/DP/emif/busB_EX
add wave -noupdate /system_tb/DUT/CPU/DP/emif/busB_MEM
add wave -noupdate /system_tb/DUT/CPU/DP/deif/ALU_Src_EX
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/zero
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/ALUOP
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/deif/busA_EX
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/mwif/Output_Port_WB
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/emif/Output_Port_MEM
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/Port_A
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/Port_B
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/aluif/Output_Port
add wave -noupdate /system_tb/DUT/CPU/DP/not_taken
add wave -noupdate /system_tb/DUT/CPU/DP/flush_ID_fw
add wave -noupdate /system_tb/DUT/CPU/DP/flush_EX_fw
add wave -noupdate /system_tb/DUT/CPU/DP/deif/imemaddr_EX
add wave -noupdate -expand -group {Dcache signals} -expand -subitemconfig {{/system_tb/DUT/CPU/CM/DCACHE/frame_a[0]} {-height 17 -childformat {{{/system_tb/DUT/CPU/CM/DCACHE/frame_a[0].tag} -radix hexadecimal}} -expand} {/system_tb/DUT/CPU/CM/DCACHE/frame_a[0].tag} {-height 17 -radix hexadecimal}} /system_tb/DUT/CPU/CM/DCACHE/frame_a
add wave -noupdate -expand -group {Dcache signals} -expand -subitemconfig {{/system_tb/DUT/CPU/CM/DCACHE/frame_b[0]} -expand} /system_tb/DUT/CPU/CM/DCACHE/frame_b
add wave -noupdate -expand -group {Dcache signals} -expand -group {Flush Check} -color Cyan /system_tb/DUT/CPU/CM/cif/dstore
add wave -noupdate -expand -group {Dcache signals} -expand -group {Flush Check} -color Cyan -subitemconfig {{/system_tb/DUT/CPU/CM/cif/daddr[31]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[30]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[29]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[28]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[27]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[26]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[25]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[24]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[23]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[22]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[21]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[20]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[19]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[18]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[17]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[16]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[15]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[14]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[13]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[12]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[11]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[10]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[9]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[8]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[7]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[6]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[5]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[4]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[3]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[2]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[1]} {-color Cyan} {/system_tb/DUT/CPU/CM/cif/daddr[0]} {-color Cyan}} /system_tb/DUT/CPU/CM/cif/daddr
add wave -noupdate -expand -group {Dcache signals} -color {Orange Red} /system_tb/DUT/CPU/CM/DCACHE/hit
add wave -noupdate -expand -group {Dcache signals} -color {Orange Red} /system_tb/DUT/CPU/CM/DCACHE/miss
add wave -noupdate -expand -group {Dcache signals} -expand -group {dp connections} -color {Orange Red} /system_tb/DUT/CPU/CM/dcif/dhit
add wave -noupdate -expand -group {Dcache signals} -expand -group {dp connections} -color {Orange Red} /system_tb/DUT/CPU/CM/dcif/flushed
add wave -noupdate -expand -group {Dcache signals} -expand -group {dp connections} -color {Orange Red} /system_tb/DUT/CPU/CM/dcif/dmemload
add wave -noupdate -expand -group {Dcache signals} -expand -group {dp connections} -color {Orange Red} /system_tb/DUT/CPU/CM/dcif/dmemstore
add wave -noupdate -expand -group {Dcache signals} -expand -group {dp connections} -color {Orange Red} /system_tb/DUT/CPU/CM/dcif/dmemaddr
add wave -noupdate -expand -group {Dcache signals} -expand -group {memory connections} -color {Orange Red} /system_tb/DUT/CPU/CM/cif/dwait
add wave -noupdate -expand -group {Ihit signals} -color Yellow /system_tb/DUT/CPU/CM/ICACHE/state
add wave -noupdate -expand -group {Ihit signals} -color Yellow /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate -expand -group {Ihit signals} -color Yellow /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/n_state
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/flush_count_a
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/flush_count_b
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/prev_dmemaddr
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/current_dmemaddr
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/prev_dhit
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/hitcnt_enable
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1191210 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 187
configure wave -valuecolwidth 297
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
WaveRestoreZoom {776 ns} {1590 ns}
