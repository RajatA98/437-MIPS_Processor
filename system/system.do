onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -expand -group RAM -color Aquamarine /system_tb/DUT/RAM/rstate
add wave -noupdate -expand -group RAM -color Aquamarine /system_tb/DUT/RAM/addr
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/iwait
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/dwait
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/iREN
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/dREN
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/dWEN
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/iload
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/dload
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/dstore
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/iaddr
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/daddr
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/ccwait
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/ccinv
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/ccwrite
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/cctrans
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/cif/ccsnoopaddr
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/DCACHE/dcache_state
add wave -noupdate -expand -group CACHE0 /system_tb/DUT/CPU/CM0/DCACHE/next_state
add wave -noupdate -expand -group CACHE0 /system_tb/DUT/CPU/CM0/DCACHE/dirty_snoop
add wave -noupdate -expand -group CACHE0 -color Pink /system_tb/DUT/CPU/CM0/ICACHE/state
add wave -noupdate -expand -group CACHE0 /system_tb/DUT/CPU/CM0/ICACHE/frames
add wave -noupdate -expand -group CPU0 /system_tb/DUT/CPU/DP0/PC_INIT
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/halt
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/ihit
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/imemREN
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/imemload
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/imemaddr
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/dhit
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/dmemREN
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/flushed
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -expand -group CPU0 -color {Green Yellow} /system_tb/DUT/CPU/DP0/RF/reg_file
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/iwait
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/dwait
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/iREN
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/dREN
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/dWEN
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/iload
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/dload
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/dstore
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/iaddr
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/daddr
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/ccwait
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/ccinv
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/ccwrite
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/cctrans
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/cif/ccsnoopaddr
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/DCACHE/dcache_state
add wave -noupdate -expand -group CACHE1 -color Orange /system_tb/DUT/CPU/CM1/ICACHE/state
add wave -noupdate -expand -group CACHE1 /system_tb/DUT/CPU/CM1/ICACHE/frames
add wave -noupdate -expand -group CPU1 /system_tb/DUT/CPU/DP1/PC_INIT
add wave -noupdate -expand -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/halt
add wave -noupdate -expand -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/ihit
add wave -noupdate -expand -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/imemREN
add wave -noupdate -expand -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/imemload
add wave -noupdate -expand -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/imemaddr
add wave -noupdate -expand -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/dhit
add wave -noupdate -expand -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/dmemREN
add wave -noupdate -expand -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/dmemWEN
add wave -noupdate -expand -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/flushed
add wave -noupdate -expand -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/dmemload
add wave -noupdate -expand -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate -expand -group CPU1 -color Violet /system_tb/DUT/CPU/dcif1/dmemaddr
add wave -noupdate -expand -group CPU1 -color Violet -subitemconfig {{/system_tb/DUT/CPU/DP1/RF/reg_file[31]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[30]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[29]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[28]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[27]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[26]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[25]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[24]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[23]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[22]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[21]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[20]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[19]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[18]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[17]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[16]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[15]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[14]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[13]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[12]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[11]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[10]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[9]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[8]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[7]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[6]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[5]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[4]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[3]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[2]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[1]} {-color Violet} {/system_tb/DUT/CPU/DP1/RF/reg_file[0]} {-color Violet}} /system_tb/DUT/CPU/DP1/RF/reg_file
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/state
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/writerequest
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/readrequest
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/flag
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/choose
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_choose
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_csnoopaddr0
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_cinv0
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_csnoopaddr1
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_cinv1
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/c_dload0
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/c_dload1
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_dload0
add wave -noupdate -expand -group MCU -color Yellow /system_tb/DUT/CPU/CC/n_dload1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {755040 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 168
configure wave -valuecolwidth 66
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
WaveRestoreZoom {0 ps} {1438 ns}
