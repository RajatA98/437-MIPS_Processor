onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /icache_tb/CLK
add wave -noupdate /icache_tb/nRST
add wave -noupdate /icache_tb/DUT/addr
add wave -noupdate /icache_tb/PROG/tb_test_num
add wave -noupdate /icache_tb/PROG/tb_test_case
add wave -noupdate -color Plum -expand -subitemconfig {{/icache_tb/DUT/frames[15]} {-color Plum -expand} {/icache_tb/DUT/frames[15].valid} {-color Plum} {/icache_tb/DUT/frames[15].tag} {-color Plum} {/icache_tb/DUT/frames[15].data} {-color Plum} {/icache_tb/DUT/frames[14]} {-color Plum} {/icache_tb/DUT/frames[13]} {-color Plum} {/icache_tb/DUT/frames[12]} {-color Plum} {/icache_tb/DUT/frames[11]} {-color Plum} {/icache_tb/DUT/frames[10]} {-color Plum} {/icache_tb/DUT/frames[9]} {-color Plum} {/icache_tb/DUT/frames[8]} {-color Plum} {/icache_tb/DUT/frames[7]} {-color Plum -expand} {/icache_tb/DUT/frames[7].valid} {-color Plum} {/icache_tb/DUT/frames[7].tag} {-color Plum} {/icache_tb/DUT/frames[7].data} {-color Plum} {/icache_tb/DUT/frames[6]} {-color Plum} {/icache_tb/DUT/frames[5]} {-color Plum} {/icache_tb/DUT/frames[4]} {-color Plum} {/icache_tb/DUT/frames[3]} {-color Plum} {/icache_tb/DUT/frames[2]} {-color Plum} {/icache_tb/DUT/frames[1]} {-color Plum} {/icache_tb/DUT/frames[0]} {-color Plum}} /icache_tb/DUT/frames
add wave -noupdate -color Cyan /icache_tb/DUT/state
add wave -noupdate -color Cyan /icache_tb/dcif/ihit
add wave -noupdate -color Cyan /icache_tb/dcif/imemREN
add wave -noupdate -color Cyan /icache_tb/dcif/imemload
add wave -noupdate -color Cyan /icache_tb/dcif/imemaddr
add wave -noupdate -color Cyan /icache_tb/cif0/iwait
add wave -noupdate -color Cyan /icache_tb/cif0/dwait
add wave -noupdate -color Cyan /icache_tb/cif0/iREN
add wave -noupdate -color Cyan /icache_tb/cif0/iload
add wave -noupdate -color Cyan /icache_tb/cif0/iaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {368214 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 160
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
WaveRestoreZoom {51 ns} {947 ns}
