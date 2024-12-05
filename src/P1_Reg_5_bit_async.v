`timescale 1ns / 100ps

module P1_Reg_5_bit_async (DataIn, DataOut, rst, clk);

    input [4:0] DataIn;
    output [4:0] DataOut;
    input rst;
    input clk;
    reg [4:0] DataReg;
    
    always @(posedge clk or posedge rst)
        if(rst)
            DataReg <= 5'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule