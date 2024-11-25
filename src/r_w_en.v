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
    reg [2 : 0] counter;

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            counter = 1'b0;
        end
        else begin
            counter = counter + 1;
            if (counter == 5) begin
                counter = 1'b1;
            end
        end
    end

    assign write_en = (counter == 3);
    assign read_en  = (counter == 4);

endmodule