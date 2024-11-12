module Mid_Part_TopModule(
    clk,
    rst,

    strip_id_1,
    strip_id_2,
    strip_id_3,
    occupied_width_1,
    occupied_width_2,
    occupied_width_3,
    width_in

    min_occupied_strip_id,
    min_occupied_strip_width
    strike_flag,
    new_occupied_strip_width
);

    input clk;
    input rst;

    input [3:0] strip_id_1;
    input [3:0] strip_id_2;
    input [3:0] strip_id_3;
    input [7:0] occupied_width_1;
    input [7:0] occupied_width_2;
    input [7:0] occupied_width_3;
    input [7:0] width_in;

    output [3:0] min_occupied_strip_id;
    output [7:0] min_occupied_strip_width;
    output strike_flag;
    output [7:0] new_occupied_strip_width;

    wire [1:0] min_occupied_width_no_s4; //sn represents for stage n
    
    //Stage 4 Combinational Logics
    Min_Occupied_Width_No  u_Min_Occupied_Width_No (
        .occupied_width_1        ( occupied_width_1         ),
        .occupied_width_2        ( occupied_width_2         ),
        .occupied_width_3        ( occupied_width_3         ),

        .min_occupied_width_no   ( min_occupied_width_no_s4 ) 
    );

    wire  [3:0]  min_occupied_strip_id_s4;   
    wire  [7:0]  min_occupied_strip_width_s4;

    Min_Occupied_Strip_Selector  u_Min_Occupied_Strip_Selector (
        .strip_id_1                ( strip_id_1                     ),
        .strip_id_2                ( strip_id_2                     ),
        .strip_id_3                ( strip_id_3                     ),
        .occupied_width_1          ( occupied_width_1               ),
        .occupied_width_2          ( occupied_width_2               ),
        .occupied_width_3          ( occupied_width_3               ),
        .min_occupied_width_no     ( min_occupied_width_no          ),

        .min_occupied_strip_id     ( min_occupied_strip_id_s4       ),
        .min_occupied_strip_width  ( min_occupied_strip_width_s4    )
    );

    //Stage 4 Registers

    wire [3:0] min_occupied_strip_id_s5;

    P1_Reg_4_bit  u_min_occupied_strip_width_s4 (
        .DataIn                  ( min_occupied_strip_id_s4 ),
        .rst                     ( rst                      ),
        .clk                     ( clk                      ),

        .DataOut                 ( min_occupied_strip_id_s5 )
    );

    wire [7:0] min_occupied_strip_width_s5;

    P1_Reg_8_bit  u_min_occupied_strip_width_s4 (
        .DataIn                  ( min_occupied_strip_width_s4  ),
        .rst                     ( rst                          ),
        .clk                     ( clk                          ),

        .DataOut                 ( min_occupied_strip_width_s5  )
    );

    wire [7:0] width_in_s5;

    P1_Reg_8_bit  u_min_occupied_strip_width_s4 (
        .DataIn                  ( width_in     ),
        .rst                     ( rst          ),
        .clk                     ( clk          ),

        .DataOut                 ( width_in_s5 )
    );

    //Stage 5 Combinational Logics
    wire  strike_flag_s5;
    wire  [7:0]  new_occupied_strip_width_s5;

    Strike_Detector  u_Strike_Detector (
        .min_occupied_strip_width  ( min_occupied_strip_width_s5    ),
        .width_in                  ( width_in_s5                    ),

        .strike_flag               ( strike_flag_s5                 ),
        .new_occupied_strip_width  ( new_occupied_strip_width_s5    )
    );

    //Stage 5 Registers

    //wire [3:0] min_occupied_strip_id_s6;

    P1_Reg_4_bit  u_min_occupied_strip_width_s5 (
        .DataIn                  ( min_occupied_strip_id_s5 ),
        .rst                     ( rst                      ),
        .clk                     ( clk                      ),

        .DataOut                 ( min_occupied_strip_id    )
    );

    //wire [7:0] min_occupied_strip_width_s6;

    P1_Reg_8_bit  u_min_occupied_strip_width_s5 (
        .DataIn                  ( min_occupied_strip_width_s5  ),
        .rst                     ( rst                          ),
        .clk                     ( clk                          ),

        .DataOut                 ( min_occupied_strip_width     )
    );

    //wire [7:0] new_occupied_strip_width_s6;

    P1_Reg_8_bit  u_min_occupied_strip_width_s5 (
        .DataIn                  ( new_occupied_strip_width_s5  ),
        .rst                     ( rst                          ),
        .clk                     ( clk                          ),

        .DataOut                 ( new_occupied_strip_width     )
    );

    //wire strike_flag_s6;
    
    P1_Reg_1_bit  u_strike_flag (
        .DataIn                  ( strike_flag_s5   ),
        .rst                     ( rst              ),
        .clk                     ( clk              ),

        .DataOut                 ( strike_flag      )
    );

    //Strike_Counter Not Utilized
endmodule