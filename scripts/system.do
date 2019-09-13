onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -divider DP
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/datomic
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/DP/current_addr
add wave -noupdate -divider {Control Unit}
add wave -noupdate /system_tb/DUT/CPU/DP/CU/iload
add wave -noupdate /system_tb/DUT/CPU/DP/CU/equal
add wave -noupdate /system_tb/DUT/CPU/DP/CU/memtoReg
add wave -noupdate /system_tb/DUT/CPU/DP/CU/memWr
add wave -noupdate /system_tb/DUT/CPU/DP/CU/ALUop
add wave -noupdate /system_tb/DUT/CPU/DP/CU/ALU_Src
add wave -noupdate /system_tb/DUT/CPU/DP/CU/EXTop
add wave -noupdate /system_tb/DUT/CPU/DP/CU/halt
add wave -noupdate /system_tb/DUT/CPU/DP/CU/PC_Src
add wave -noupdate /system_tb/DUT/CPU/DP/CU/RegDst
add wave -noupdate /system_tb/DUT/CPU/DP/CU/RegWr
add wave -noupdate /system_tb/DUT/CPU/DP/CU/Wsel
add wave -noupdate /system_tb/DUT/CPU/DP/CU/iREN
add wave -noupdate -expand /system_tb/DUT/CPU/DP/CU/rt
add wave -noupdate -divider registers
add wave -noupdate /system_tb/DUT/CPU/DP/RF/reg_file
add wave -noupdate -divider extender
add wave -noupdate /system_tb/DUT/CPU/DP/EXT/imm16
add wave -noupdate /system_tb/DUT/CPU/DP/EXT/extended
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {45720 ps} 0}
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
WaveRestoreZoom {0 ps} {235232 ps}
