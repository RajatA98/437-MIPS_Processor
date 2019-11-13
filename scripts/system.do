onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -group RAM -color Aquamarine /system_tb/DUT/RAM/rstate
add wave -noupdate -group RAM -color Aquamarine /system_tb/DUT/RAM/addr
add wave -noupdate -group CACHE0 /system_tb/DUT/CPU/DP0/mwif/halt_WB
add wave -noupdate -group CACHE0 /system_tb/DUT/CPU/DP0/mwif/enable
add wave -noupdate -group CACHE0 /system_tb/DUT/CPU/DP0/d_request
add wave -noupdate -group CACHE0 /system_tb/DUT/CPU/CM0/DCACHE/ddif/halt
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/iwait
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/dwait
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/iREN
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/dREN
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/dWEN
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/iload
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/dload
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/dstore
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/iaddr
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/daddr
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/ccwait
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/ccinv
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/ccwrite
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/cctrans
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/ccsnoopaddr
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/DCACHE/dcache_state
add wave -noupdate -group CACHE0 /system_tb/DUT/CPU/CM0/DCACHE/flush_count_a
add wave -noupdate -group CACHE0 /system_tb/DUT/CPU/CM0/DCACHE/flush_count_b
add wave -noupdate -group CACHE0 /system_tb/DUT/CPU/CM0/DCACHE/snoopaddr
add wave -noupdate -group CACHE0 /system_tb/DUT/CPU/CM0/DCACHE/dirty_snoop
add wave -noupdate -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/ICACHE/state
add wave -noupdate -group CACHE0 /system_tb/DUT/CPU/CM0/DCACHE/hit
add wave -noupdate -group CACHE0 /system_tb/DUT/CPU/CM0/DCACHE/miss
add wave -noupdate -group CACHE0 /system_tb/DUT/CPU/CM0/DCACHE/addr
add wave -noupdate -group CACHE0 /system_tb/DUT/CPU/CM0/ICACHE/frames
add wave -noupdate -group {DCACHE FRAMES CORE0} -expand -subitemconfig {{/system_tb/DUT/CPU/CM0/DCACHE/frame_a[0]} -expand {/system_tb/DUT/CPU/CM0/DCACHE/frame_a[0].data} -expand} /system_tb/DUT/CPU/CM0/DCACHE/frame_a
add wave -noupdate -group {DCACHE FRAMES CORE0} -expand -subitemconfig {{/system_tb/DUT/CPU/CM0/DCACHE/frame_b[1]} -expand {/system_tb/DUT/CPU/CM0/DCACHE/frame_b[1].data} -expand} /system_tb/DUT/CPU/CM0/DCACHE/frame_b
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/instr_EX
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/instr_MEM
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/instr_WB
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/RegWr_MEM
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/memWr_MEM
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/memtoReg_MEM
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/RegWr_WB
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/memtoReg_WB
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/Asel
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/Bsel
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/rt_EX
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/rt_MEM
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/rt_WB
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/it_EX
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/it_MEM
add wave -noupdate -group {FU Core0} /system_tb/DUT/CPU/DP0/FU/it_WB
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/instr_ID
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/instr_EX
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/instr_MEM
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/RegWr_EX
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/memWr_EX
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/RegWr_MEM
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/memWr_MEM
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/flush_ID
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/flush_EX
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/flush_MEM
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/pc_enable
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/enable_ID
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/enable_EX
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/enable_MEM
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/hazard
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/rt_ID
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/rt_EX
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/rt_MEM
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/it_ID
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/it_EX
add wave -noupdate -group {HU Core0} /system_tb/DUT/CPU/DP0/HU/it_MEM
add wave -noupdate -expand -group CPU0 /system_tb/DUT/CPU/DP0/PC_INIT
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/halt
add wave -noupdate -expand -group CPU0 /system_tb/DUT/CPU/DP0/pc_halt
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/ihit
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/imemREN
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/imemload
add wave -noupdate -expand -group CPU0 /system_tb/DUT/CPU/DP0/next_addr
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/imemaddr
add wave -noupdate -expand -group CPU0 /system_tb/DUT/CPU/DP0/branch_addr
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/dhit
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/dmemREN
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/flushed
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -expand -group CPU0 -color {Green Yellow} -subitemconfig {{/system_tb/DUT/CPU/DP0/RF/reg_file[31]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[30]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[29]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[28]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[27]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[26]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[25]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[24]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[23]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[22]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[21]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[20]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[19]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[18]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[17]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[16]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[15]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[14]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[13]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[12]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[11]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[10]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[9]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[8]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[7]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[6]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[5]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[4]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[3]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[2]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[1]} {-color {Green Yellow} -height 17} {/system_tb/DUT/CPU/DP0/RF/reg_file[0]} {-color {Green Yellow} -height 17}} /system_tb/DUT/CPU/DP0/RF/reg_file
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/iwait
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/dwait
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/iREN
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/dREN
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/dWEN
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/iload
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/dload
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/dstore
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/iaddr
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/daddr
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/ccwait
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/ccinv
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/ccwrite
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/cctrans
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/ccsnoopaddr
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/DCACHE/dcache_state
add wave -noupdate -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/ICACHE/state
add wave -noupdate -group CACHE1 /system_tb/DUT/CPU/CM1/ICACHE/frames
add wave -noupdate -group {CORE 1 DCACHE FRAMES} /system_tb/DUT/CPU/CM1/DCACHE/frame_a
add wave -noupdate -group {CORE 1 DCACHE FRAMES} /system_tb/DUT/CPU/CM1/DCACHE/frame_b
add wave -noupdate -group CPU1 /system_tb/DUT/CPU/DP1/PC_INIT
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/halt
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/ihit
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/imemREN
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/imemload
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/imemaddr
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/dhit
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/dmemREN
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/dmemWEN
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/flushed
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/dmemload
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/dmemaddr
add wave -noupdate -group CPU1 -color Violet /system_tb/DUT/CPU/DP1/RF/reg_file
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/state
add wave -noupdate -group MCU /system_tb/DUT/CPU/CC/ccif/ramaddr
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/writerequest
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/readrequest
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/flag
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/choose
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_csnoopaddr0
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_cinv0
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_csnoopaddr1
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_cinv1
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/c_dload0
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/c_dload1
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_dload0
add wave -noupdate -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_dload1
add wave -noupdate -group MCU /system_tb/DUT/CPU/CC/drequest1
add wave -noupdate -group MCU /system_tb/DUT/CPU/CC/drequest0
add wave -noupdate /system_tb/DUT/CPU/DP0/deif/opcode
add wave -noupdate /system_tb/DUT/CPU/DP0/deif/opcode_EX
add wave -noupdate -radix binary /system_tb/DUT/CPU/DP0/emif/opcode_MEM
add wave -noupdate /system_tb/DUT/CPU/DP0/emif/instr_MEM
add wave -noupdate /system_tb/DUT/CPU/DP0/emif/zero_MEM
add wave -noupdate -color {Orange Red} /system_tb/DUT/CPU/DP0/flush_ID_fw
add wave -noupdate -color {Orange Red} /system_tb/DUT/CPU/DP0/flush_EX_fw
add wave -noupdate -color {Orange Red} /system_tb/DUT/CPU/DP0/flush_MEM_fw
add wave -noupdate /system_tb/DUT/CPU/DP0/fdif/flush
add wave -noupdate /system_tb/DUT/CPU/DP0/deif/flush
add wave -noupdate /system_tb/DUT/CPU/DP0/emif/flush
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3020814 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 168
configure wave -valuecolwidth 176
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
WaveRestoreZoom {2905 ns} {3331 ns}
