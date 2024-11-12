//////////////////////////////////////////////////////////
// function: register for output x and y
//
// author: Yudong Zhou
//
// Create time: 11/11/2024
//////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module output_reg (
    // input signals
    input               clk,
    input               rstn,
    input [7 : 0]       x_in,
    input [7 : 0]       y_in,
    input [3 : 0]       strike_in,

    // output signals
    output reg [7 : 0]  x_out,
    output reg [7 : 0]  y_out,
    output reg [3 : 0]  strike_out
);

    always @(posedge clk or negedge rstn) begin
        if(~rstn) begin
            x_out <= 0;
            y_out <= 0;
            strike_out <= 0;
        end
        else begin
            x_out <= x_in;
            y_out <= y_in;
            strike_out <= strike_in;
        end
    end
    
endmodule