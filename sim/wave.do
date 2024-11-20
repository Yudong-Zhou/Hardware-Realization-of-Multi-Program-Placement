onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /M216A_TB/TEST_FILE_INPUT
add wave -noupdate /M216A_TB/TEST_FILE_OUTPUT
add wave -noupdate /M216A_TB/clk
add wave -noupdate /M216A_TB/rst
add wave -noupdate /M216A_TB/height_i
add wave -noupdate /M216A_TB/width_i
add wave -noupdate /M216A_TB/strike_o
add wave -noupdate /M216A_TB/index_x_o
add wave -noupdate /M216A_TB/index_y_o
add wave -noupdate /M216A_TB/input_file
add wave -noupdate /M216A_TB/output_file
add wave -noupdate /M216A_TB/expected_index_x
add wave -noupdate /M216A_TB/expected_index_y
add wave -noupdate /M216A_TB/count
add wave -noupdate /M216A_TB/latency_check
add wave -noupdate /M216A_TB/file_data_input
add wave -noupdate /M216A_TB/file_data_output
add wave -noupdate /M216A_TB/first_iteration
add wave -noupdate /M216A_TB/uut/occupied_width
add wave -noupdate /M216A_TB/uut/str_id_1
add wave -noupdate /M216A_TB/uut/str_id_2
add wave -noupdate /M216A_TB/uut/str_id_3
add wave -noupdate /M216A_TB/uut/occ_width_1
add wave -noupdate /M216A_TB/uut/occ_width_2
add wave -noupdate /M216A_TB/uut/occ_width_3
add wave -noupdate /M216A_TB/uut/min_occupied_strip_id
add wave -noupdate /M216A_TB/uut/min_occupied_strip_width
add wave -noupdate /M216A_TB/uut/find_row_strip_id_1
add wave -noupdate /M216A_TB/uut/find_row_strip_id_2
add wave -noupdate /M216A_TB/uut/find_row_strip_id_3
add wave -noupdate /M216A_TB/uut/min_occupied_strip_id_s4
add wave -noupdate /M216A_TB/uut/min_occupied_strip_width_s4
add wave -noupdate /M216A_TB/uut/min_occupied_strip_id_s5
add wave -noupdate /M216A_TB/uut/min_occupied_strip_width_s5
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {87868 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 340
configure wave -valuecolwidth 196
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
WaveRestoreZoom {963553 ps} {1015603 ps}
