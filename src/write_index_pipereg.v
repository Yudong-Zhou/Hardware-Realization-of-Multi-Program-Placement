//////////////////////////////////////////////////////////
// function: pipeline register between write and index
//
// author: Yudong Zhou
//
// Create time: 11/11/2024
//////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module write_index_pipereg (
    // input signals
    input               clk,
    input               rstn,
    input [3 : 0]       strip_ID_in,
    input [7 : 0]       occupied_width_in,
    input [3 : 0]       strike_in,

    // output signals
    output reg [3 : 0]  strip_ID_out,
    output reg [7 : 0]  occupied_width_out,
    output reg [3 : 0]  strike_out
);

    always @(posedge clk or negedge rstn) begin
        if(~rstn) begin
            strip_ID_out        <= 0;
            occupied_width_out  <= 0;
            strike_out          <= 0;
        end
        else begin
            strip_ID_out        <= strip_ID_in;
            occupied_width_out  <= occupied_width_in;
            strike_out          <= strike_in;
        end
    end
    
endmodule