onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /control_unit_tb/CLK
add wave -noupdate /control_unit_tb/nRST
add wave -noupdate /control_unit_tb/iload
add wave -noupdate /control_unit_tb/equal
add wave -noupdate /control_unit_tb/memtoReg
add wave -noupdate /control_unit_tb/memWr
add wave -noupdate /control_unit_tb/ALUop
add wave -noupdate /control_unit_tb/ALU_Src
add wave -noupdate /control_unit_tb/EXTop
add wave -noupdate /control_unit_tb/halt
add wave -noupdate /control_unit_tb/PC_Src
add wave -noupdate /control_unit_tb/RegDst
add wave -noupdate /control_unit_tb/RegWr
add wave -noupdate /control_unit_tb/Wsel
add wave -noupdate /control_unit_tb/iREN
add wave -noupdate /control_unit_tb/PROG/tb_test_num
add wave -noupdate /control_unit_tb/PROG/tb_test_case
add wave -noupdate /control_unit_tb/PROG/check_outputs/test
add wave -noupdate /control_unit_tb/PROG/check_outputs/expected_memtoReg
add wave -noupdate /control_unit_tb/PROG/check_outputs/expected_memWr
add wave -noupdate /control_unit_tb/PROG/check_outputs/expected_ALUop
add wave -noupdate /control_unit_tb/PROG/check_outputs/expected_ALU_Src
add wave -noupdate /control_unit_tb/PROG/check_outputs/expected_EXTop
add wave -noupdate /control_unit_tb/PROG/check_outputs/expected_halt
add wave -noupdate /control_unit_tb/PROG/check_outputs/expected_PC_Src
add wave -noupdate /control_unit_tb/PROG/check_outputs/expected_RegDst
add wave -noupdate /control_unit_tb/PROG/check_outputs/expected_RegWr
add wave -noupdate /control_unit_tb/PROG/check_outputs/expected_Wsel
add wave -noupdate /control_unit_tb/PROG/check_outputs/expected_iREN
add wave -noupdate /control_unit_tb/PROG/tb_blip
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15 ns} 0}
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
WaveRestoreZoom {0 ns} {352 ns}
