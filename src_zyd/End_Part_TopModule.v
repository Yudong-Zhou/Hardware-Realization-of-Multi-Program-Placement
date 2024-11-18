//////////////////////////////////////////////////////////////////////////////////////
// function: topmodule for Hardware Realization of Multi-Program Placement (HRMPP)
//
// author: Yudong Zhou
//
// Create time: 11/11/2024
//////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module End_Part_TopModule (
    // input signals
    input               clk,
    input               rst,

    input               strike_flag_write,
    input [3 : 0]       strip_ID_write,
    input [7 : 0]       old_occupied_width_write,
    input [7 : 0]       new_occupied_width_write,
    input [3 : 0]       strike_counter_write,

    // output signals
    output [7 : 0]  index_x_output,
    output [7 : 0]  index_y_output,
    output [3 : 0]  strike_counter_output
);
    
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
    reg [7 : 0]         register_array[13 : 0];

//////////////////////////////////////////////////////////
    // write to register array

    always @(posedge clk) begin
        register_array[strip_ID_write] <= new_occupied_width_write - 1; // store occupied width from 0
    end

//////////////////////////////////////////////////////////
    // pipeline registers between write and index

    P1_Reg_4_bit P1_Reg_4_bit_inst1 (
        .DataIn                 (strike_counter_write),
        .rst                    (rst), 
        .clk                    (clk),
        
        .DataOut                (strike_counter_index)
    );

    P1_Reg_4_bit P1_Reg_4_bit_inst2 (
        .DataIn                 (strip_ID_write),
        .rst                    (rst), 
        .clk                    (clk),
        
        .DataOut                (strip_ID_index)
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst1 (
        .DataIn                 (old_occupied_width_write),
        .rst                    (rst), 
        .clk                    (clk),
        
        .DataOut                (occupied_width_index)
    );

    P1_Reg_1_bit P1_Reg_1_bit_inst1 (
        .DataIn                 (strike_flag_write),
        .rst                    (rst), 
        .clk                    (clk),
        
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
        .rst                    (rst), 
        .clk                    (clk),
        
        .DataOut                (strike_counter_outstage)
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst2 (
        .DataIn                 (x_index),
        .rst                    (rst), 
        .clk                    (clk),
        
        .DataOut                (x_outstage)
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst3 (
        .DataIn                 (y_index),
        .rst                    (rst), 
        .clk                    (clk),
        
        .DataOut                (y_outstage)
    );

//////////////////////////////////////////////////////////
    // output registers for x and y

    P1_Reg_4_bit P1_Reg_4_bit_inst4 (
        .DataIn                 (strike_counter_outstage),
        .rst                    (rst), 
        .clk                    (clk),
        
        .DataOut                (strike_counter_output)
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst4 (
        .DataIn                 (x_outstage),
        .rst                    (rst), 
        .clk                    (clk),
        
        .DataOut                (index_x_output)
    );

    P1_Reg_8_bit P1_Reg_8_bit_inst5 (
        .DataIn                 (y_outstage),
        .rst                    (rst), 
        .clk                    (clk),
        
        .DataOut                (index_y_output)
    );

endmodule