onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /arp_tb/CLK
add wave -noupdate /arp_tb/ARESET
add wave -noupdate /arp_tb/MY_MAC
add wave -noupdate /arp_tb/MY_IPV4
add wave -noupdate /arp_tb/DATA_VALID_RX
add wave -noupdate /arp_tb/DATA_RX
add wave -noupdate /arp_tb/DATA_ACK_TX
add wave -noupdate /arp_tb/DATA_VALID_TX
add wave -noupdate /arp_tb/DUT/state
add wave -noupdate /arp_tb/DATA_TX
add wave -noupdate /arp_tb/DUT/n_DATA_TX
add wave -noupdate /arp_tb/DUT/temp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {125 ns} 0}
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
WaveRestoreZoom {1 ns} {174 ns}
