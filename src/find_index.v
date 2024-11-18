//////////////////////////////////////////////////////////
// function: find the output (x, y) index
//
// author: Yudong Zhou
//
// Create time: 11/11/2024
//////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module find_index (
    // input signals
    input [3 : 0]       strip_ID_in,
    input [7 : 0]       occupied_width_in,
    //input [3 : 0]       strike_in,
    input               strike_flag_in,

    // output signals
    output reg [7 : 0]  x_out,
    output reg [7 : 0]  y_out
    //output reg [3 : 0]  strike_out
);

    always @(*) begin
        if(strike_flag_in) begin
            x_out <= 128;
            y_out <= 128;
        end
        else begin
            // calculate y
            case(strip_ID_in)
                'd1:    y_out <= 0; 
                'd2:    y_out <= 8;
                'd3:    y_out <= 16;
                'd4:    y_out <= 25;
                'd5:    y_out <= 32;
                'd6:    y_out <= 42;
                'd7:    y_out <= 48;
                'd8:    y_out <= 59;
                'd9:    y_out <= 64;
                'd10:   y_out <= 76;
                'd11:   y_out <= 80;
                'd12:   y_out <= 96;
                'd13:   y_out <= 112;
                default: y_out <= 0;
            endcase
            // calculate x: whether +1 depends on how to store occupied width in register_array
            //             (from 0 or from 1)
            x_out <= occupied_width_in + 1; // (from 0)
            // x_out <= occupied_width_in + 1; // (from 1)
        end
        //strike_out <= strike_in;
    end

endmodule