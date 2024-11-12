//////////////////////////////////////////////////////////
// function: topmodule for Hardware Realization of Multi-Program Placement (HRMPP)
//
// author: Yudong Zhou
//
// Create time: 11/11/2024
//////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module HRMPP_top (
    // input signals
    input               clk,
    input               rstn,
    input [4 : 0]       height_in,
    input [4 : 0]       width_in,

    // output signals
    output reg [7 : 0]  index_x_out,
    output reg [7 : 0]  index_y_out,
    output reg [3 : 0]  strike_out
);

    wire [3 : 0]    strip_ID_write_index;
    wire [3 : 0]    strip_ID_index;

    wire [7 : 0]    occupied_width_write;
    wire [7 : 0]    occupied_width_write_index;
    wire [7 : 0]    occupied_width_index;

    wire            strike_flag;
    wire [3 : 0]    strike_write_index;
    wire [3 : 0]    strike_index;
    wire [3 : 0]    strike_index_output;
    wire [3 : 0]    strike_output_reg;

    wire [7 : 0]    x_index_output;
    wire [7 : 0]    y_index_output;
    wire [7 : 0]    x_output_reg;
    wire [7 : 0]    y_output_reg;
    
    // define register array
    reg [7 : 0]     register_array[13 : 0];

    // write to register array
    always @(*) begin
        register_array[strip_ID] <= occupied_width_write; // store occupied width from 1
        //register_array[strip_ID] <= occupied_width_write - 1; // store occupied width from 0
    end

    assign occupied_width_write_index = occupied_width_write;

    // pipeline register between write and index
    write_index_pipereg write_index_pipereg_inst (
        .clk(clk),
        .rstn(rstn),
        .strip_ID_in(strip_ID_write_index),
        .occupied_width_in(occupied_width_write_index),
        .strike_in(strike_write_index),
        .strip_ID_out(strip_ID_index),
        .occupied_width_out(occupied_width_index),
        .strike_out(strike_index)
    );

    // find the output (x, y) index
    find_index find_index_inst (
        .strip_ID_in(strip_ID_index),
        .occupied_width_in(occupied_width_index),
        .strike_in(strike_index),
        .strike_flag_in(strike_flag),
        .x_out(x_index_output),
        .y_out(y_index_output),
        .strike_out(strike_index_output)
    );

    // pipeline register between index and output
    index_out_pipereg index_out_pipereg_inst (
        .clk(clk),
        .rstn(rstn),
        .x_in(x_index_output),
        .y_in(y_index_output),
        .strike_in(strike_index_output),
        .x_out(x_output_reg),
        .y_out(y_output_reg),
        .strike_out(strike_output_reg)
    );

    // output register for x and y
    output_reg output_reg_inst (
        .clk(clk),
        .rstn(rstn),
        .x_in(x_output_reg),
        .y_in(y_output_reg),
        .strike_in(strike_output_reg),
        .x_out(index_x_out),
        .y_out(index_y_out),
        .strike_out(strike_out)
    );

endmodule