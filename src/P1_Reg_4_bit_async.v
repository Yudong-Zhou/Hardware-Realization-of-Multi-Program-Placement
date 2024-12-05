`timescale 1ns / 100ps

module P1_Reg_4_bit_async (DataIn, DataOut, rst, clk);

    input [3:0] DataIn;
    output [3:0] DataOut;
    input rst;
    input clk;
    reg [3:0] DataReg;
    
    always @(posedge clk or posedge rst)
        if(rst)
            DataReg <= 4'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule