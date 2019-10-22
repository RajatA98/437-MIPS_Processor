onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/PROG/tb_test_num
add wave -noupdate /dcache_tb/PROG/tb_test_case
add wave -noupdate -expand -group {Outputs to datapath} -color {Medium Violet Red} /dcache_tb/DUT/ddif/dhit
add wave -noupdate -expand -group {Outputs to datapath} -color {Medium Violet Red} /dcache_tb/DUT/ddif/flushed
add wave -noupdate -expand -group {Outputs to datapath} -color {Medium Violet Red} /dcache_tb/DUT/ddif/dmemload
add wave -noupdate -expand -group {Inputs from dp} -color Cyan /dcache_tb/DUT/ddif/halt
add wave -noupdate -expand -group {Inputs from dp} -color Cyan /dcache_tb/DUT/ddif/dmemREN
add wave -noupdate -expand -group {Inputs from dp} -color Cyan /dcache_tb/DUT/ddif/dmemWEN
add wave -noupdate -expand -group {Inputs from dp} -color Cyan /dcache_tb/DUT/ddif/dmemstore
add wave -noupdate -expand -group {Inputs from dp} -color Cyan /dcache_tb/DUT/ddif/dmemaddr
add wave -noupdate -expand -group {Outputs to mem} -color {Orange Red} /dcache_tb/DUT/dmif/dREN
add wave -noupdate -expand -group {Outputs to mem} -color {Orange Red} /dcache_tb/DUT/dmif/dWEN
add wave -noupdate -expand -group {Outputs to mem} -color {Orange Red} /dcache_tb/DUT/dmif/dstore
add wave -noupdate -expand -group {Outputs to mem} -color {Orange Red} /dcache_tb/DUT/dmif/daddr
add wave -noupdate -expand -group {Inputs from mem} -color Yellow /dcache_tb/DUT/dmif/dwait
add wave -noupdate -expand -group {Inputs from mem} -color Yellow /dcache_tb/DUT/dmif/dload
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/dcache_state
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/hit_count
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/addr
add wave -noupdate -expand -group {Internal Dcache} -color Orchid -expand -subitemconfig {{/dcache_tb/DUT/frame_a[7]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_a[6]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_a[5]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_a[4]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_a[3]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_a[2]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_a[1]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_a[0]} {-color Orchid -height 17 -expand} {/dcache_tb/DUT/frame_a[0].valid} {-color Orchid -height 17} {/dcache_tb/DUT/frame_a[0].dirty} {-color Orchid -height 17} {/dcache_tb/DUT/frame_a[0].tag} {-color Orchid -height 17} {/dcache_tb/DUT/frame_a[0].data} {-color Orchid -height 17 -expand} {/dcache_tb/DUT/frame_a[0].data[1]} {-color Orchid} {/dcache_tb/DUT/frame_a[0].data[0]} {-color Orchid}} /dcache_tb/DUT/frame_a
add wave -noupdate -expand -group {Internal Dcache} -color Orchid -expand -subitemconfig {{/dcache_tb/DUT/frame_b[7]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_b[6]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_b[5]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_b[4]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_b[3]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_b[2]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_b[1]} {-color Orchid -height 17} {/dcache_tb/DUT/frame_b[0]} {-color Orchid -height 17 -expand} {/dcache_tb/DUT/frame_b[0].valid} {-color Orchid -height 17} {/dcache_tb/DUT/frame_b[0].dirty} {-color Orchid -height 17} {/dcache_tb/DUT/frame_b[0].tag} {-color Orchid -height 17} {/dcache_tb/DUT/frame_b[0].data} {-color Orchid -height 17 -expand} {/dcache_tb/DUT/frame_b[0].data[1]} {-color Orchid} {/dcache_tb/DUT/frame_b[0].data[0]} {-color Orchid}} /dcache_tb/DUT/frame_b
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/set_a
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/set_b
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/lru_enable
add wave -noupdate -expand -group {Internal Dcache} -color {Spring Green} /dcache_tb/DUT/used_a
add wave -noupdate -expand -group {Internal Dcache} -color {Spring Green} /dcache_tb/DUT/used_b
add wave -noupdate -expand -group {Internal Dcache} /dcache_tb/DUT/n_used_a
add wave -noupdate -expand -group {Internal Dcache} /dcache_tb/DUT/n_used_b
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/match_a
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/match_b
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/hit
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/miss
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/dirty
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/valid_a
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/valid_b
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/flush_count_a
add wave -noupdate -expand -group {Internal Dcache} -color Orchid /dcache_tb/DUT/flush_count_b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {679152 ps} 0}
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
WaveRestoreZoom {532 ns} {940 ns}
