onerror {resume}
quietly set dataset_list [list sim milestone2]
if {[catch {datasetcheck $dataset_list}]} {abort}
quietly WaveActivateNextPane {} 0
add wave -noupdate sim:/uart_tx_tb/dut/clk
add wave -noupdate sim:/uart_tx_tb/dut/rst
add wave -noupdate sim:/uart_tx_tb/dut/baud_tick
add wave -noupdate sim:/uart_tx_tb/dut/tx_start_d
add wave -noupdate sim:/uart_tx_tb/dut/tx_start_pulse
add wave -noupdate sim:/uart_tx_tb/dut/tx_start
add wave -noupdate sim:/uart_tx_tb/dut/state
add wave -noupdate sim:/uart_tx_tb/clk
add wave -noupdate sim:/uart_tx_tb/rst
add wave -noupdate sim:/uart_tx_tb/baud_tick
add wave -noupdate sim:/uart_tx_tb/tx_start
add wave -noupdate sim:/uart_tx_tb/data_in
add wave -noupdate sim:/uart_tx_tb/tx
add wave -noupdate sim:/uart_tx_tb/tx_busy
add wave -noupdate sim:/uart_tx_tb/dut/clk
add wave -noupdate sim:/uart_tx_tb/dut/rst
add wave -noupdate sim:/uart_tx_tb/dut/baud_tick
add wave -noupdate sim:/uart_tx_tb/dut/tx_start
add wave -noupdate sim:/uart_tx_tb/dut/data_in
add wave -noupdate sim:/uart_tx_tb/dut/tx
add wave -noupdate sim:/uart_tx_tb/dut/tx_busy
add wave -noupdate sim:/uart_tx_tb/dut/state
add wave -noupdate sim:/uart_tx_tb/dut/bit_index
add wave -noupdate sim:/uart_tx_tb/dut/shift_reg
add wave -noupdate sim:/uart_tx_tb/dut/tx_start_d
add wave -noupdate sim:/uart_tx_tb/dut/tx_start_pulse
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {161642 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 212
configure wave -valuecolwidth 47
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {4786576 ps} {5253339 ps}
