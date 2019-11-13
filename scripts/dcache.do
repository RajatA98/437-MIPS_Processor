onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/PROG/tb_test_num
add wave -noupdate /dcache_tb/PROG/tb_test_case
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dcache_state
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/halt
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/ihit
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/imemREN
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/imemload
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/imemaddr
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/dhit
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/datomic
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/dmemREN
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/dmemWEN
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/flushed
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/dmemload
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/dmemstore
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/ddif/dmemaddr
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/iwait
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/dwait
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/iREN
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/dREN
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/dWEN
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/iload
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/dload
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/dstore
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/iaddr
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/daddr
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/ccwait
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/ccinv
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/ccwrite
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/cctrans
add wave -noupdate -expand -group DC0 /dcache_tb/DC0/dmif/ccsnoopaddr
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dcache_state
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/halt
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/ihit
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/imemREN
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/imemload
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/imemaddr
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/dhit
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/datomic
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/dmemREN
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/dmemWEN
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/flushed
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/dmemload
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/dmemstore
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/ddif/dmemaddr
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/iwait
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/dwait
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/iREN
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/dREN
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/dWEN
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/iload
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/dload
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/dstore
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/iaddr
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/daddr
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/ccwait
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/ccinv
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/ccwrite
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/cctrans
add wave -noupdate -expand -group DC1 /dcache_tb/DC1/dmif/ccsnoopaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {657109374 ps} 0}
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
WaveRestoreZoom {814 ns} {2572 ns}
