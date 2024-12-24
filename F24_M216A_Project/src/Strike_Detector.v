module Strike_Detector(
    min_occupied_strip_width,
    width_in,

    strike_flag,
    new_occupied_strip_width
);

    input [7:0] min_occupied_strip_width;
    input [4:0] width_in;

    output reg strike_flag;
    output reg [7:0] new_occupied_strip_width;

    always @(*) begin
        new_occupied_strip_width = min_occupied_strip_width + {3'b000 , width_in};
        if (new_occupied_strip_width > 8'd128) 
            strike_flag = 1;
        else
            strike_flag = 0;
    end

endmodule