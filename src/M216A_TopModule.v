`timescale 1ns / 100ps

//Do NOT Modify This Module
module P1_Reg_8_bit (DataIn, DataOut, rst, clk);

    input [7:0] DataIn;
    output [7:0] DataOut;
    input rst;
    input clk;
    reg [7:0] DataReg;
   
    always @(posedge clk)
  	if(rst)
            DataReg <= 8'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule

//Do NOT Modify This Module
module P1_Reg_5_bit (DataIn, DataOut, rst, clk);

    input [4:0] DataIn;
    output [4:0] DataOut;
    input rst;
    input clk;
    reg [4:0] DataReg;
    
    always @(posedge clk)
        if(rst)
            DataReg <= 5'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule

//Do NOT Modify This Module
module P1_Reg_4_bit (DataIn, DataOut, rst, clk);

    input [3:0] DataIn;
    output [3:0] DataOut;
    input rst;
    input clk;
    reg [3:0] DataReg;
    
    always @(posedge clk)
        if(rst)
            DataReg <= 4'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule

module P1_Reg_1_bit (DataIn, DataOut, rst, clk);

    input       DataIn;
    output      DataOut;
    input       rst;
    input       clk;
    reg         DataReg;
    
    always @(posedge clk)
        if(rst)
            DataReg <= 1'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule

//Do NOT Modify This Module's I/O Definition
module M216A_TopModule(
    clk_i,
    width_i,
    height_i,
    index_x_o,
    index_y_o,
    strike_o,
    rst_i
);

    input clk_i;
    input [4:0] width_i;
    input [4:0] height_i;
    output [7:0] index_x_o;
    output [7:0] index_y_o;
    output [3:0] strike_o;
    input rst_i;

    wire clk_i;
    wire [4:0] width_i;
    wire [4:0] height_i;
    wire rst_i;

    //Add your code below 
    //Make sure to Register the outputs using the Register modules given above

    wire [3:0] str_id_1, str_id_2, str_id_3;
    wire [7:0] occ_width_1, occ_width_2, occ_width_3;
    wire [4:0] width_front;
    wire [4:0] height_front;

    wire [3:0] min_occupied_strip_id;
    wire [7:0] min_occupied_strip_width;
    wire strike_flag;
    wire [7:0] new_occupied_strip_width;
    wire [3:0] strike_count;

    /*
    Front_Topmodule front_topmodule (

        .clk(clk_i),
        .rst(rst_i),

        .height_in(height_i),
        .width_in(width_i),

        .str_id_1(str_id_1),
        .str_id_2(str_id_2),
        .str_id_3(str_id_3),
        .occ_width_1(occ_width_1),
        .occ_width_2(occ_width_2),
        .occ_width_3(occ_width_3),
        .width_out(width_front),
        .height_out()
    );
    */

//Front Part By Xia

    // Input sampling stage

    wire [4:0] height_input, width_input;

    P1_Reg_5_bit height_in_reg (.DataIn(height_i), .DataOut(height_input), .rst(rst_i), .clk(clk_i));
    P1_Reg_5_bit width_in_reg (.DataIn(width_i), .DataOut(width_input), .rst(rst_i), .clk(clk_i));

    // Find Row stage

    wire [4:0] row_stage_height, row_stage_width;
    wire [3:0] internal_str_id_1, internal_str_id_2, internal_str_id_3;

    Find_Row find_row_stage (.clk(clk_i), .height_in(height_input), .width_in(width_input), 
                            .str_id_1(internal_str_id_1), .str_id_2(internal_str_id_2), .str_id_3(internal_str_id_3));
    P1_Reg_5_bit find_row_height_reg(.DataIn(height_input), .DataOut(row_stage_height), .rst(rst_i), .clk(clk_i));
    P1_Reg_5_bit find_row_width_reg(.DataIn(width_input), .DataOut(row_stage_width), .rst(rst_i), .clk(clk_i)); 

    // Read reg arr stage

    wire [4:0] read_arr_stage_height, read_arr_stage_width;
    wire [3:0] strip_id_1, strip_id_2, strip_id_3;
    reg [7:0] occ_width_1_reg, occ_width_2_reg, occ_width_3_reg;
    reg [7:0] occupied_width [0:13];// DOUBLE CHECK

    always @(posedge clk_i) begin
        if(rst_i) begin
            occupied_width[0] <= 8'd128;
            occupied_width[1] <= 0;
            occupied_width[2] <= 0;
            occupied_width[3] <= 0;
            occupied_width[4] <= 0;
            occupied_width[5] <= 0;
            occupied_width[6] <= 0;
            occupied_width[7] <= 0;
            occupied_width[8] <= 0;
            occupied_width[9] <= 0;
            occupied_width[10] <= 0;
            occupied_width[11] <= 0;
            occupied_width[12] <= 0;
            occupied_width[13] <= 0;
        end
    end

    // Assign output registers to module outputs

    assign occ_width_1 = occ_width_1_reg;
    assign occ_width_2 = occ_width_2_reg;
    assign occ_width_3 = occ_width_3_reg;
    assign str_id_1 = strip_id_1;
    assign str_id_2 = strip_id_2;
    assign str_id_3 = strip_id_3;

    always @(posedge clk_i)
    begin
        occ_width_1_reg <= occupied_width[internal_str_id_1];
        occ_width_2_reg <= occupied_width[internal_str_id_2];
        occ_width_3_reg <= occupied_width[internal_str_id_3];
    end

    // Register connections to the outputs

    //height will not be used afterwards
    //P1_Reg_5_bit read_arr_height_reg(.DataIn(row_stage_height), .DataOut(read_arr_stage_height), .rst(rst), .clk(clk_i));
    P1_Reg_5_bit read_arr_width_reg(.DataIn(row_stage_width), .DataOut(read_arr_stage_width), .rst(rst), .clk(clk_i));
    P1_Reg_4_bit read_arr_str_id_1_reg(.DataIn(internal_str_id_1), .DataOut(strip_id_1), .rst(rst), .clk(clk_i));
    P1_Reg_4_bit read_arr_str_id_2_reg(.DataIn(internal_str_id_2), .DataOut(strip_id_2), .rst(rst), .clk(clk_i));
    P1_Reg_4_bit read_arr_str_id_3_reg(.DataIn(internal_str_id_3), .DataOut(strip_id_3), .rst(rst), .clk(clk_i));

    assign width_front = read_arr_stage_width;
    //assign height_front = read_arr_stage_height;

//Mid Part By Lin

    /*
    Mid_Part_TopModule mid_part_topmodule (

        .clk(clk_i),
        .rst(rst_i),

        .strip_id_1(str_id_1),
        .strip_id_2(str_id_2),
        .strip_id_3(str_id_3),
        .occupied_width_1(occ_width_1),
        .occupied_width_2(occ_width_2),
        .occupied_width_3(occ_width_3),
        .width_in(width_front),

        .min_occupied_strip_id(min_occupied_strip_id),
        .min_occupied_strip_width(min_occupied_strip_width),
        .strike_flag(strike_flag),
        .new_occupied_strip_width(new_occupied_strip_width),
        .strike_count(strike_count)
    );
    */

    wire [1:0] min_occupied_width_no_s4; //sn represents for stage n

    //Min occupied width Combinational Logics

    Min_Occupied_Width_No  u_Min_Occupied_Width_No (
        .occupied_width_1        ( occ_width_1         ),
        .occupied_width_2        ( occ_width_2         ),
        .occupied_width_3        ( occ_width_3         ),
        .min_occupied_width_no   ( min_occupied_width_no_s4 ) 
    );

    wire  [3:0]  min_occupied_strip_id_s4;   
    wire  [7:0]  min_occupied_strip_width_s4;

    Min_Occupied_Strip_Selector  u_Min_Occupied_Strip_Selector (
        .strip_id_1                ( str_id_1                     ),
        .strip_id_2                ( str_id_2                     ),
        .strip_id_3                ( str_id_3                     ),
        .occupied_width_1          ( occ_width_1               ),
        .occupied_width_2          ( occ_width_2               ),
        .occupied_width_3          ( occ_width_3               ),
        .min_occupied_width_no     ( min_occupied_width_no_s4       ),
        .min_occupied_strip_id     ( min_occupied_strip_id_s4       ),
        .min_occupied_strip_width  ( min_occupied_strip_width_s4    )
    );

    //Stage 4 Registers

    wire [3:0] min_occupied_strip_id_s5;

    P1_Reg_4_bit  u_min_occupied_strip_id_s4 (
        .DataIn                  ( min_occupied_strip_id_s4 ),
        .rst                     ( rst_i                    ),
        .clk                     ( clk_i                    ),
        .DataOut                 ( min_occupied_strip_id_s5 )
    );

    wire [7:0] min_occupied_strip_width_s5;

    P1_Reg_8_bit  u_min_occupied_strip_width_s4 (
        .DataIn                  ( min_occupied_strip_width_s4  ),
        .rst                     ( rst_i                        ),
        .clk                     ( clk_i                        ),
        .DataOut                 ( min_occupied_strip_width_s5  )
    );

    wire [4:0] width_in_s5;

    P1_Reg_5_bit  u_width_in_s4 (
        .DataIn                  ( width_front  ),
        .rst                     ( rst_i        ),
        .clk                     ( clk_i        ),
        .DataOut                 ( width_in_s5  )
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

    P1_Reg_4_bit  u_min_occupied_strip_id_s5 (
        .DataIn                  ( min_occupied_strip_id_s5 ),
        .rst                     ( rst_i                    ),
        .clk                     ( clk_i                    ),
        .DataOut                 ( min_occupied_strip_id    )
    );


    P1_Reg_8_bit  u_min_occupied_strip_width_s5 (
        .DataIn                  ( min_occupied_strip_width_s5  ),
        .rst                     ( rst_i                        ),
        .clk                     ( clk_i                        ),
        .DataOut                 ( min_occupied_strip_width     )
    );


    P1_Reg_8_bit  u_new_occupied_strip_width_s5 (
        .DataIn                  ( new_occupied_strip_width_s5  ),
        .rst                     ( rst_i                        ),
        .clk                     ( clk_i                        ),
        .DataOut                 ( new_occupied_strip_width     )
    );


    P1_Reg_1_bit  u_strike_flag (
        .DataIn                  ( strike_flag_s5   ),
        .rst                     ( rst_i            ),
        .clk                     ( clk_i            ),
        .DataOut                 ( strike_flag      )
    );

    Strike_Counter  u_Strike_Counter (
        .strike_flag             ( strike_flag_s5   ),
        .clk                     ( clk_i            ),
        .rst                     ( rst_i            ),
        .strike_count            ( strike_count     )
    );

//End Part By Zhou

    /*
    End_Part_TopModule end_part_topmodule (
        .clk(clk_i),
        .rst(rst_i),

        .strike_flag_write(strike_flag),
        .strip_ID_write(min_occupied_strip_id),
        .old_occupied_width_write(min_occupied_strip_width),
        .new_occupied_width_write(new_occupied_strip_width),
        .strike_counter_write(strike_count),
        
        .index_x_output(index_x_o),
        .index_y_output(index_y_o),
        .strike_counter_output(strike_o)
    );
    */

    wire [3 : 0]        strip_ID_index;
    wire [7 : 0]        occupied_width_index;
    wire                strike_flag_index;
    wire [3 : 0]        strike_counter_index;

    wire [7 : 0]        x_index;
    wire [7 : 0]        y_index;

    wire [7 : 0]        x_outstage;
    wire [7 : 0]        y_outstage;
    wire [3 : 0 ]       strike_counter_outstage;

    // define register array
    //reg [7 : 0]         register_array[13 : 0];

//////////////////////////////////////////////////////////
    // write to register array

    always @(posedge clk_i) begin
        occupied_width[min_occupied_strip_id] <= new_occupied_strip_width - 1; // store occupied width from 0
    end

//////////////////////////////////////////////////////////
    // pipeline registers between write and index

    P1_Reg_4_bit P1_Reg_4_bit_inst1 (
        .DataIn                 (strike_count),
        .rst                    (rst_i), 
        .clk                    (clk_i),
        
        .DataOut                (strike_counter_index)
    );

    P1_Reg_4_bit P1_Reg_4_bit_inst2 (
        .DataIn                 (min_occupied_strip_id),
        .rst                    (rst_i), 
        .clk                    (clk_i),
        
        .DataOut                (strip_ID_index)
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst1 (
        .DataIn                 (min_occupied_strip_width),
        .rst                    (rst_i), 
        .clk                    (clk_i),
        
        .DataOut                (occupied_width_index)
    );

    P1_Reg_1_bit P1_Reg_1_bit_inst1 (
        .DataIn                 (strike_flag),
        .rst                    (rst_i), 
        .clk                    (clk_i),
        
        .DataOut                (strike_flag_index)
    );

//////////////////////////////////////////////////////////
    // find the output (x, y) index

    find_index find_index_inst (
        .strip_ID_in            (strip_ID_index),
        .occupied_width_in      (occupied_width_index),
        .strike_flag_in         (strike_flag_index),

        .x_out                  (x_index),
        .y_out                  (y_index)
    );

//////////////////////////////////////////////////////////
    // pipeline registers between index and output

    P1_Reg_4_bit P1_Reg_4_bit_inst3 (
        .DataIn                 (strike_counter_index),
        .rst                    (rst_i), 
        .clk                    (clk_i),
        
        .DataOut                (strike_counter_outstage)
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst2 (
        .DataIn                 (x_index),
        .rst                    (rst_i), 
        .clk                    (clk_i),
        
        .DataOut                (x_outstage)
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst3 (
        .DataIn                 (y_index),
        .rst                    (rst_i), 
        .clk                    (clk_i),
        
        .DataOut                (y_outstage)
    );

//////////////////////////////////////////////////////////
    // output registers for x and y

    P1_Reg_4_bit P1_Reg_4_bit_inst4 (
        .DataIn                 (strike_counter_outstage),
        .rst                    (rst_i), 
        .clk                    (clk_i),
        
        .DataOut                (strike_o)
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst4 (
        .DataIn                 (x_outstage),
        .rst                    (rst_i), 
        .clk                    (clk_i),
        
        .DataOut                (index_x_o)
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst5 (
        .DataIn                 (y_outstage),
        .rst                    (rst_i), 
        .clk                    (clk_i),
        
        .DataOut                (index_y_o)
    );

endmodule
