module Min_Occupied_Width_No (
    occupied_width_1,
    occupied_width_2,
    occupied_width_3,
    min_occupied_width_no
);

    //if certain occupied width is not used, set it as 7'd128
    input [7:0] occupied_width_1;
    input [7:0] occupied_width_2;
    input [7:0] occupied_width_3;

    //generate the number of strip that has min_occupied_width
    output [1:0] min_occupied_width_no; 

    reg [1:0] occupied_width_no;

    always @(*) begin
        if (occupied_width_1 > occupied_width_2) 
            occupied_width_no = (occupied_width_2 > occupied_width_3)? 2'd3 : 2'd2;
        else 
            occupied_width_no = (occupied_width_1 > occupied_width_3)? 2'd3 : 2'd1;
    end

    assign min_occupied_width_no = occupied_width_no;

endmodule