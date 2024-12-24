////////////////////////////////////////////////////////////////////////////////////////////////////
// TOP MODULE for M216A Project: Hardware Realization of Multi-Program Placement (Rectangle Filling)
//
// Author: Haoxuan Xia, Zepeng Lin, Yudong Zhou
//
// Create Time: 11/11/2024
// 
// FUNCTION: 8-Stage Implementation
// 1. Input sampling stage                  [I]
// 2. Find Row stage                        [Fr]
// 3. Read reg arr stage                    [R]
// 4. Determine Min occupied width stage    [M]
// 5. Strike Detector stage                 [S]
// 6. Write to register array stage         [W]
// 7. Find the output (x, y) index stage    [Fi]
// 8. Output registers stage                [O]
//
// Pipeline Display:
// CLK: --1--2--3--4--5--6--7--8--9--10--11--12--13--14--15--16--...
// STAGE: I  Fr R  M  S  W  Fi O
//                    I  Fr R  M  S  W   Fi  O
//                                I  Fr  R   M   S   W   Fi  O
//
////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module M216A_TopModule_noclkdiv(
    input           clk_i,    
    input           rst_i,
    input  [4 : 0]  width_i,
    input  [4 : 0]  height_i,

    output [7 : 0]  index_x_o,
    output [7 : 0]  index_y_o,
    output [3 : 0]  strike_o
);
    
    // Input sampling stage
    wire [4 : 0]    height_input;
    wire [4 : 0]    width_input;

    // Find Row stage
    wire [4 : 0]    row_stage_height;
    wire [4 : 0]    row_stage_width;
    wire [3 : 0]    internal_str_id_1;
    wire [3 : 0]    internal_str_id_2;
    wire [3 : 0]    internal_str_id_3;
    wire [3 : 0]    find_row_strip_id_1;
    wire [3 : 0]    find_row_strip_id_2;
    wire [3 : 0]    find_row_strip_id_3;

    // Read reg arr stage
    wire [4 : 0]    read_arr_stage_width;
    wire [4 : 0]    width_front;
    wire [7 : 0]    occ_width_1_reg;
    wire [7 : 0]    occ_width_2_reg;
    wire [7 : 0]    occ_width_3_reg;

    // Min occupied width Combinational Logics
    wire [1 : 0]    min_occupied_width_no_s4;
    wire [3 : 0]    min_occupied_strip_id_s4;   
    wire [7 : 0]    min_occupied_strip_width_s4;

    wire [3 : 0]    str_id_1; 
    wire [3 : 0]    str_id_2;
    wire [3 : 0]    str_id_3;
    wire [7 : 0]    occ_width_1;
    wire [7 : 0]    occ_width_2;
    wire [7 : 0]    occ_width_3;

    wire [7 : 0]    min_occupied_strip_width_s5;
    wire [3 : 0]    min_occupied_strip_id_s5; 
    wire [3 : 0]    min_occupied_strip_id;
    wire [7 : 0]    min_occupied_strip_width;
    wire            strike_flag;
    wire [7 : 0]    new_occupied_strip_width;
    wire [3 : 0]    strike_count;

    // Stage 5 Combinational Logics
    wire            strike_flag_s5;
    wire [7 : 0]    new_occupied_strip_width_s5;
    wire [4 : 0]    width_in_s5;
    
    // write  to register array
    wire [3 : 0]    strip_ID_index;
    wire [7 : 0]    occupied_width_index;
    wire            strike_flag_index;
    wire [3 : 0]    strike_counter_index;

    // find the output (x, y) index
    wire [7 : 0]    x_index;
    wire [7 : 0]    y_index;

    // output registers for x and y
    wire [7 : 0]    x_outstage;
    wire [7 : 0]    y_outstage;
    wire [3 : 0]    strike_counter_outstage;

////////////////////////////////////////////////////////////////////////////////////////////////////
    // Input sampling stage

    P1_Reg_5_bit height_in_reg (
        .clk        (clk_i          ),
        .rst        (rst_i          ), 
        .DataIn     (height_i       ), 
        .DataOut    (height_input   )
    );
    
    P1_Reg_5_bit width_in_reg (
        .clk        (clk_i          ),
        .rst        (rst_i          ), 
        .DataIn     (width_i        ), 
        .DataOut    (width_input    )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // Find Row stage

    Find_Row find_row_stage (
        .height_in  (height_input       ), 
        .width_in   (width_input        ), 
        .str_id_1   (internal_str_id_1  ), 
        .str_id_2   (internal_str_id_2  ), 
        .str_id_3   (internal_str_id_3  )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // pipeline registers between find row and read reg arr

    P1_Reg_5_bit find_row_height_reg (
        .clk        (clk_i                  ),
        .rst        (rst_i                  ), 
        .DataIn     (height_input           ),
        .DataOut    (row_stage_height       )
    );

    P1_Reg_5_bit find_row_width_reg (
        .clk        (clk_i                  ),
        .rst        (rst_i                  ), 
        .DataIn     (width_input            ), 
        .DataOut    (row_stage_width        )
    ); 

    P1_Reg_4_bit find_row_str_id_1_reg (
        .clk        (clk_i                  ),
        .rst        (rst_i                  ), 
        .DataIn     (internal_str_id_1      ), 
        .DataOut    (find_row_strip_id_1    )
    );

    P1_Reg_4_bit find_row_str_id_2_reg (
        .clk        (clk_i                  ),
        .rst        (rst_i                  ), 
        .DataIn     (internal_str_id_2      ), 
        .DataOut    (find_row_strip_id_2    )
    );

    P1_Reg_4_bit find_row_str_id_3_reg (
        .clk        (clk_i                  ),
        .rst        (rst_i                  ),
        .DataIn     (internal_str_id_3      ), 
        .DataOut    (find_row_strip_id_3    )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // Read reg arr stage

    r_w_enable r_w_enable_inst (
        .clk        (clk_i                  ),
        .rst        (rst_i                  ),
        .write_en   (write_en               ),
        .read_en    (read_en                )
    );

    ram ram (
        .clk        (clk_i                  ),
        .rst        (rst_i                  ),
        .write_en   (write_en               ),
        .read_en    (read_en                ),
        .addr_write (min_occupied_strip_id  ),
        .data_in    (new_occupied_strip_width),
        .addr_read1 (find_row_strip_id_1    ),
        .addr_read2 (find_row_strip_id_2    ),
        .addr_read3 (find_row_strip_id_3    ),
        .data_out1  (occ_width_1_reg        ),
        .data_out2  (occ_width_2_reg        ),
        .data_out3  (occ_width_3_reg        )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // pipeline registers between read reg arr and min occupied width

    P1_Reg_5_bit read_arr_width_reg (
        .clk        (clk_i                  ),
        .rst        (rst_i                  ),
        .DataIn     (row_stage_width        ), 
        .DataOut    (read_arr_stage_width   )
    );

    P1_Reg_4_bit read_arr_str_id_1_reg (
        .clk        (clk_i                  ),
        .rst        (rst_i                  ),
        .DataIn     (find_row_strip_id_1    ), 
        .DataOut    (str_id_1               )
    );

    P1_Reg_4_bit read_arr_str_id_2_reg (
        .clk        (clk_i                  ),
        .rst        (rst_i                  ),
        .DataIn     (find_row_strip_id_2    ), 
        .DataOut    (str_id_2               )
    );

    P1_Reg_4_bit read_arr_str_id_3_reg (
        .clk        (clk_i                  ),
        .rst        (rst_i                  ),
        .DataIn     (find_row_strip_id_3    ), 
        .DataOut    (str_id_3               )
    );

    assign occ_width_1 = occ_width_1_reg;
    assign occ_width_2 = occ_width_2_reg;
    assign occ_width_3 = occ_width_3_reg;
    assign width_front = read_arr_stage_width;

////////////////////////////////////////////////////////////////////////////////////////////////////
    //Min occupied width Combinational Logics
 
    Min_Occupied_Width_No  u_Min_Occupied_Width_No (
        .occupied_width_1           (occ_width_1                ),
        .occupied_width_2           (occ_width_2                ),
        .occupied_width_3           (occ_width_3                ),
        .min_occupied_width_no      (min_occupied_width_no_s4   ) 
    );

    Min_Occupied_Strip_Selector  u_Min_Occupied_Strip_Selector (
        .strip_id_1                 (str_id_1                   ),
        .strip_id_2                 (str_id_2                   ),
        .strip_id_3                 (str_id_3                   ),
        .occupied_width_1           (occ_width_1                ),
        .occupied_width_2           (occ_width_2                ),
        .occupied_width_3           (occ_width_3                ),
        .min_occupied_width_no      (min_occupied_width_no_s4   ),
        .min_occupied_strip_id      (min_occupied_strip_id_s4   ),
        .min_occupied_strip_width   (min_occupied_strip_width_s4)
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // pipeline registers between min occupied width and stage 5

    P1_Reg_4_bit  u_min_occupied_strip_id_s4 (
        .clk        (clk_i                      ),
        .rst        (rst_i                      ),
        .DataIn     (min_occupied_strip_id_s4   ),
        .DataOut    (min_occupied_strip_id_s5   )
    );

    P1_Reg_8_bit  u_min_occupied_strip_width_s4 (
        .clk        (clk_i                      ),
        .rst        (rst_i                      ),
        .DataIn     (min_occupied_strip_width_s4),
        .DataOut    (min_occupied_strip_width_s5)
    );

    P1_Reg_5_bit  u_width_in_s4 (
        .clk        (clk_i                      ),
        .rst        (rst_i                      ),
        .DataIn     (width_front                ),
        .DataOut    (width_in_s5                )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // Stage 5 Combinational Logics

    Strike_Detector  u_Strike_Detector (
        .min_occupied_strip_width   (min_occupied_strip_width_s5),
        .width_in                   (width_in_s5                ),
        .strike_flag                (strike_flag_s5             ),
        .new_occupied_strip_width   (new_occupied_strip_width_s5)
    );
    
    Strike_Counter  u_Strike_Counter (
        .clk            (clk_i               ),
        .rst            (rst_i              ),
        .strike_flag    (strike_flag_s5     ),
        .strike_count   (strike_count       )  
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // pipeline registers between stage 5 and write array

    P1_Reg_4_bit  u_min_occupied_strip_id_s5 (
        .clk        (clk_i                       ),
        .rst        (rst_i                      ),            
        .DataIn     (min_occupied_strip_id_s5   ),
        .DataOut    (min_occupied_strip_id      )
    );

    P1_Reg_8_bit  u_min_occupied_strip_width_s5 (
        .clk        (clk_i                       ),
        .rst        (rst_i                      ),
        .DataIn     (min_occupied_strip_width_s5),
        .DataOut    (min_occupied_strip_width   )
    );

    P1_Reg_8_bit  u_new_occupied_strip_width_s5 (
        .clk        (clk_i                       ),
        .rst        (rst_i                      ),
        .DataIn     (new_occupied_strip_width_s5),
        .DataOut    (new_occupied_strip_width   )
    );

    P1_Reg_1_bit  u_strike_flag (
        .clk        (clk_i                       ),
        .rst        (rst_i                      ),
        .DataIn     (strike_flag_s5             ),
        .DataOut    (strike_flag                )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // write to register array

////////////////////////////////////////////////////////////////////////////////////////////////////
    // pipeline registers between write and index

    P1_Reg_4_bit P1_Reg_4_bit_inst1 (
        .clk        (clk_i                      ),
        .rst        (rst_i                      ), 
        .DataIn     (strike_count               ),
        .DataOut    (strike_counter_index       )
    );

    P1_Reg_4_bit P1_Reg_4_bit_inst2 (
        .clk        (clk_i                      ),
        .rst        (rst_i                      ), 
        .DataIn     (min_occupied_strip_id      ),
        .DataOut    (strip_ID_index             )
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst1 (
        .clk        (clk_i                      ),
        .rst        (rst_i                      ), 
        .DataIn     (min_occupied_strip_width   ),
        .DataOut    (occupied_width_index)
    );

    P1_Reg_1_bit P1_Reg_1_bit_inst1 (
        .clk        (clk_i                      ),
        .rst        (rst_i                      ), 
        .DataIn     (strike_flag                ),
        .DataOut    (strike_flag_index          )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // find the output (x, y) index

    find_index find_index_inst (
        .strip_ID_in            (strip_ID_index         ),
        .occupied_width_in      (occupied_width_index   ),
        .strike_flag_in         (strike_flag_index      ),
        .x_out                  (x_index                ),
        .y_out                  (y_index                )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // pipeline registers between index and output

    P1_Reg_4_bit P1_Reg_4_bit_inst3 (
        .clk        (clk_i                      ),
        .rst        (rst_i                      ), 
        .DataIn     (strike_counter_index       ),
        .DataOut    (strike_counter_outstage    )
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst2 (
        .clk        (clk_i                      ),        
        .rst        (rst_i                      ), 
        .DataIn     (x_index                    ),
        .DataOut    (x_outstage                 )
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst3 (
        .clk        (clk_i                      ),
        .rst        (rst_i                      ), 
        .DataIn     (y_index                    ),
        .DataOut    (y_outstage                 )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // output registers for x and y

    P1_Reg_4_bit P1_Reg_4_bit_inst4 (
        .clk        (clk_i                      ),
        .rst        (rst_i                      ), 
        .DataIn     (strike_counter_outstage    ),
        .DataOut    (strike_o                   )
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst4 (
        .clk        (clk_i                      ),
        .rst        (rst_i                      ), 
        .DataIn     (x_outstage                 ),
        .DataOut    (index_x_o                  )
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst5 (
        .clk        (clk_i                      ),
        .rst        (rst_i                      ), 
        .DataIn     (y_outstage                 ),
        .DataOut    (index_y_o                  )
    );

endmodule
