module Find_Row(clk, height_in, width_in, str_id_1, str_id_2, str_id_3);
    input clk;
    input [4:0] height_in, width_in;
    output reg [3:0] str_id_1, str_id_2, str_id_3;

    always @(*)
    begin
        case (height_in)
            5'd4: {str_id_1, str_id_2, str_id_3}    = {4'd10, 4'd8,  4'd0};
            5'd5: {str_id_1, str_id_2, str_id_3}    = {4'd8,  4'd6,  4'd0};
            5'd6: {str_id_1, str_id_2, str_id_3}    = {4'd6,  4'd4,  4'd0};
            5'd7: {str_id_1, str_id_2, str_id_3}    = {4'd4,  4'd1,  4'd2};
            5'd8: {str_id_1, str_id_2, str_id_3}    = {4'd1,  4'd2,  4'd3};
            5'd9: {str_id_1, str_id_2, str_id_3}    = {4'd3,  4'd5,  4'd0};
            5'd10:{str_id_1, str_id_2, str_id_3}    = {4'd5,  4'd7,  4'd0};
            5'd11:{str_id_1, str_id_2, str_id_3}    = {4'd7,  4'd9,  4'd0};
            5'd12:{str_id_1, str_id_2, str_id_3}    = {4'd9,  4'd0,  4'd0};
            5'd13, 5'd14, 5'd15, 5'd16:  
                  {str_id_1, str_id_2, str_id_3}    = {4'd13, 4'd12, 4'd11};
            default: 
                  {str_id_1, str_id_2, str_id_3}    = {4'd0,  4'd0,  4'd0};
        endcase
    end
endmodule