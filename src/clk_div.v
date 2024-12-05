//////////////////////////////////////////////////////////
// function: clock frequency division
//
// author: Yudong Zhou
//
// Create time: 11/22/2024
//////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module clk_div(
    input       clk_in,
    input       rst_in,

    output      clk1_out,
    output      clk2_out,
    output      clk3_out,
    output      clk4_out
);
    
    parameter   CLK1 = 0;
    parameter   CLK2 = 1;
    parameter   CLK3 = 2;
    parameter   CLK4 = 3;
    
    reg [1 : 0] current_state;
    reg [1 : 0] next_state;
    reg         clk1;
    reg         clk2;
    reg         clk3;
    reg         clk4;

    always @(posedge clk_in or posedge rst_in) begin
        if (rst_in) begin
            current_state = 2'b00;
            next_state    = 2'b00;
            clk1          = 1'b0;
            clk2          = 1'b0;
            clk3          = 1'b0;
            clk4          = 1'b0;
        end
        else begin
            case (current_state)
                CLK1: begin
                    next_state  = CLK2;
                    clk1        = 1'b1;
                    clk2        = 1'b0;
                    clk3        = 1'b0;
                    clk4        = 1'b0;
                end
                CLK2: begin
                    next_state  = CLK3;
                    clk1        = 1'b0;
                    clk2        = 1'b1;
                    clk3        = 1'b0;
                    clk4        = 1'b0;
                end
                CLK3: begin
                    next_state  = CLK4;
                    clk1        = 1'b0;
                    clk2        = 1'b0;
                    clk3        = 1'b1;
                    clk4        = 1'b0;
                end
                CLK4: begin
                    next_state  = CLK1;
                    clk1        = 1'b0;
                    clk2        = 1'b0;
                    clk3        = 1'b0;
                    clk4        = 1'b1;
                end
                default: begin
                    next_state  = CLK4;
                    clk1        = 1'b0;
                    clk2        = 1'b0;
                    clk3        = 1'b0;
                    clk4        = 1'b0;
                end
            endcase
            current_state = next_state;
        end
    end

    assign clk1_out = clk2;
    assign clk2_out = clk3;
    assign clk3_out = clk4;
    assign clk4_out = clk1;

endmodule