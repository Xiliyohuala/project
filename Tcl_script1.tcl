#Setup pin setting for EP4C6_board
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"

set_location_assignment PIN_23 -to clk

set_location_assignment PIN_143 -to data_out[0]
set_location_assignment PIN_142 -to data_out[1]
set_location_assignment PIN_141 -to data_out[2]
set_location_assignment PIN_138 -to data_out[3]
set_location_assignment PIN_137 -to data_out[4]
set_location_assignment PIN_136 -to data_out[5]
set_location_assignment PIN_135 -to data_out[6]

set_location_assignment PIN_129 -to segcom[0]
set_location_assignment PIN_3 -to segcom[1]
set_location_assignment PIN_2 -to segcom[2]
set_location_assignment PIN_1 -to segcom[3]
set_location_assignment PIN_144 -to segdot

set_location_assignment PIN_30 -to key1
set_location_assignment PIN_32 -to key2
