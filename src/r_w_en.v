//////////////////////////////////////////////////////////
// function: provde read and write enable signal
//
// author: Yudong Zhou
//
// Create time: 11/24/2024
//////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module r_w_enable (
    input       clk,
    input       rst,

    output wire write_en,
    output wire read_en
);
    reg [1 : 0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'b00;
        end
        else begin
            counter <= counter + 1;
        end
    end

    assign write_en = (counter == 2'b10);
    assign read_en  = (counter == 2'b11);

endmodule