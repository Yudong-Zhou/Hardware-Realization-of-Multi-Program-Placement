module Top_module (
    input       clk_i,
    input       rst_i,
    input [4:0] height_i,
    input [4:0] width_i,

    output [7:0]    index_x_o,
    output [7:0]    index_y_o,
    output [3:0]    strike_o
);

    wire [3:0] str_id_1, str_id_2, str_id_3;
    wire [7:0] occ_width_1, occ_width_2, occ_width_3;
    wire [4:0] width_front;

    wire [3:0] min_occupied_strip_id;
    wire [7:0] min_occupied_strip_width;
    wire strike_flag;
    wire [7:0] new_occupied_strip_width;
    wire [3:0] strike_count;

    Front_Topmodule front_topmodule (
        .clk(clk_i),
        .rst(rst_i),
        .height_in(height_i),
        .width_in(width_i),

        .str_id_1(str_id_1),
        .str_id_2(str_id_2),
        .str_id_3(str_id_3),
        .occ_width_1(occ_width_1),
        .occ_width_2(occ_width_2),
        .occ_width_3(occ_width_3),
        .width_out(width_front),
        .height_out()
    );

    Mid_Part_TopModule mid_part_topmodule (
        .clk(clk_i),
        .rst(rst_i),

        .strip_id_1(str_id_1),
        .strip_id_2(str_id_2),
        .strip_id_3(str_id_3),
        .occupied_width_1(occ_width_1),
        .occupied_width_2(occ_width_2),
        .occupied_width_3(occ_width_3),
        .width_in(width_front),

        .min_occupied_strip_id(min_occupied_strip_id),
        .min_occupied_strip_width(min_occupied_strip_width),
        .strike_flag(strike_flag),
        .new_occupied_strip_width(new_occupied_strip_width),
        .strike_count(strike_count)
    );

    End_Part_TopModule end_part_topmodule (
        .clk(clk_i),
        .rst(rst_i),

        .strike_flag_write(strike_flag),
        .strip_ID_write(min_occupied_strip_id),
        .old_occupied_width_write(min_occupied_strip_width),
        .new_occupied_width_write(new_occupied_strip_width),
        .strike_counter_write(strike_count),

        .index_x_output(index_x_o),
        .index_y_output(index_y_o),
        .strike_counter_output(strike_o)
    );

endmodule