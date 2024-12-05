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

module M216A_TopModule(
    input           clk_i,    
    input           rst_i,
    input  [4 : 0]  width_i,
    input  [4 : 0]  height_i,

    output [7 : 0]  index_x_o,
    output [7 : 0]  index_y_o,
    output [3 : 0]  strike_o
);

    // clock division module
    wire            clk1;
    wire            clk2;
    wire            clk3;
    wire            clk4;
    
    // Input sampling stage
    wire [4 : 0]    height_input;
    wire [4 : 0]    width_input;

    // Find Row stage
    wire [3 : 0]    internal_str_id_1;
    wire [3 : 0]    internal_str_id_2;
    wire [3 : 0]    internal_str_id_3;

    // Read reg arr stage
    wire [7 : 0]    occ_width_1_reg;
    wire [7 : 0]    occ_width_2_reg;
    wire [7 : 0]    occ_width_3_reg;
    wire            write_en;
    wire            read_en;

    // Min occupied width Combinational Logics
    wire [1 : 0]    min_occupied_width_no_s4;
    wire [3 : 0]    min_occupied_strip_id_s4;   
    wire [7 : 0]    min_occupied_strip_width_s4;

    wire [7 : 0]    min_occupied_strip_width_s5;
    wire [3 : 0]    min_occupied_strip_id_s5; 
    wire [3 : 0]    min_occupied_strip_id;
    wire [7 : 0]    new_occupied_strip_width;
    wire [3 : 0]    strike_count;

    // Stage 5 Combinational Logics
    wire            strike_flag_s5;
    wire [7 : 0]    new_occupied_strip_width_s5;
    wire [4 : 0]    width_in_s5;

    // find the output (x, y) index
    wire [7 : 0]    x_index;
    wire [7 : 0]    y_index;

////////////////////////////////////////////////////////////////////////////////////////////////////
    // Clock division module
    clk_div clk_div_inst (
        .clk_in     (clk_i  ),
        .rst_in     (rst_i  ),
        .clk1_out   (clk1   ),
        .clk2_out   (clk2   ),
        .clk3_out   (clk3   ),
        .clk4_out   (clk4   )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // Input sampling stage
    
    P1_Reg_5_bit_async height_in_reg (
        .clk        (clk1           ),
        .rst        (rst_i          ), 
        .DataIn     (height_i       ), 
        .DataOut    (height_input   )
    );
    
    P1_Reg_5_bit_async width_in_reg (
        .clk        (clk1           ),
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

////////////////////////////////////////////////////////////////////////////////////////////////////
    // Read reg arr stage

    r_w_enable r_w_enable_inst (
        .clk        (clk_i                  ),
        .rst        (rst_i                  ),
        .write_en   (write_en               ),
        .read_en    (read_en                )
    );

    ram ram (
        .clk        (clk_i && (clk2 || clk3)),
        .rst        (rst_i                  ),
        .write_en   (write_en               ),
        .read_en    (read_en                ),
        .addr_write (min_occupied_strip_id  ),
        .data_in    (new_occupied_strip_width),
        .addr_read1 (internal_str_id_1      ),
        .addr_read2 (internal_str_id_2      ),
        .addr_read3 (internal_str_id_3      ),
        .data_out1  (occ_width_1_reg        ),
        .data_out2  (occ_width_2_reg        ),
        .data_out3  (occ_width_3_reg        )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // pipeline registers between read reg arr and min occupied width

////////////////////////////////////////////////////////////////////////////////////////////////////
    //Min occupied width Combinational Logics
 
    Min_Occupied_Width_No  u_Min_Occupied_Width_No (
        .occupied_width_1           (occ_width_1_reg            ),
        .occupied_width_2           (occ_width_2_reg            ),
        .occupied_width_3           (occ_width_3_reg            ),
        .min_occupied_width_no      (min_occupied_width_no_s4   ) 
    );

    Min_Occupied_Strip_Selector  u_Min_Occupied_Strip_Selector (
        .strip_id_1                 (internal_str_id_1          ),
        .strip_id_2                 (internal_str_id_2          ),
        .strip_id_3                 (internal_str_id_3          ),
        .occupied_width_1           (occ_width_1_reg            ),
        .occupied_width_2           (occ_width_2_reg            ),
        .occupied_width_3           (occ_width_3_reg            ),
        .min_occupied_width_no      (min_occupied_width_no_s4   ),
        .min_occupied_strip_id      (min_occupied_strip_id_s4   ),
        .min_occupied_strip_width   (min_occupied_strip_width_s4)
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // pipeline registers between min occupied width and stage 5

    P1_Reg_4_bit_async  u_min_occupied_strip_id_s4 (
        .clk        (clk4                       ),
        .rst        (rst_i                      ),
        .DataIn     (min_occupied_strip_id_s4   ),
        .DataOut    (min_occupied_strip_id_s5   )
    );

    P1_Reg_8_bit_async  u_min_occupied_strip_width_s4 (
        .clk        (clk4                       ),
        .rst        (rst_i                      ),
        .DataIn     (min_occupied_strip_width_s4),
        .DataOut    (min_occupied_strip_width_s5)
    );

    P1_Reg_5_bit_async  u_width_in_s4 (
        .clk        (clk4                       ),
        .rst        (rst_i                      ),
        .DataIn     (width_input                ),
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
        .clk            (clk1               ),
        .rst            (rst_i              ),
        .strike_flag    (strike_flag_s5     ),
        .strike_count   (strike_count       )  
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // pipeline registers between stage 5 and write array
    
    P1_Reg_4_bit_async  u_min_occupied_strip_id_s5 (
        .clk        (clk1                       ),
        .rst        (rst_i                      ),            
        .DataIn     (min_occupied_strip_id_s5   ),
        .DataOut    (min_occupied_strip_id      )
    );

    P1_Reg_8_bit_async  u_new_occupied_strip_width_s5 (
        .clk        (clk1                       ),
        .rst        (rst_i                      ),
        .DataIn     (new_occupied_strip_width_s5),
        .DataOut    (new_occupied_strip_width   )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // write to register array

////////////////////////////////////////////////////////////////////////////////////////////////////
    // pipeline registers between write and index

////////////////////////////////////////////////////////////////////////////////////////////////////
    // find the output (x, y) index

    find_index find_index_inst (
        .strip_ID_in            (min_occupied_strip_id_s5   ),
        .occupied_width_in      (min_occupied_strip_width_s5),
        .strike_flag_in         (strike_flag_s5             ),
        .x_out                  (x_index                    ),
        .y_out                  (y_index                    )
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
    // pipeline registers between index and output

////////////////////////////////////////////////////////////////////////////////////////////////////
    // output registers for x and y

    P1_Reg_4_bit_async P1_Reg_4_bit_inst4 (
        .clk        (clk4                       ),
        .rst        (rst_i                      ), 
        .DataIn     (strike_count               ),
        .DataOut    (strike_o                   )
    );

    P1_Reg_8_bit_async P1_Reg_8_bit_inst4 (
        .clk        (clk4                       ),
        .rst        (rst_i                      ), 
        .DataIn     (x_index                    ),
        .DataOut    (index_x_o                  )
    );

    P1_Reg_8_bit_async P1_Reg_8_bit_inst5 (
        .clk        (clk4                       ),
        .rst        (rst_i                      ), 
        .DataIn     (y_index                    ),
        .DataOut    (index_y_o                  )
    );

endmodule
