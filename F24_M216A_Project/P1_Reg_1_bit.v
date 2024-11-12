module P1_Reg_1_bit (DataIn, DataOut, rst, clk);

    input DataIn;
    output DataOut;
    input rst;
    input clk;
    reg DataReg;
    
    always @(posedge clk)
        if(rst)
            DataReg <= 1'b0;
        else
            DataReg <= DataIn;
    assign DataOut = DataReg;
endmodule