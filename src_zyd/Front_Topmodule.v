module Front_Topmodule(
    clk,
    rst,
    height_in,
    width_in,

    str_id_1,
    str_id_2,
    str_id_3,
    occ_width_1,
    occ_width_2,
    occ_width_3,
    width_out,
    height_out
);

    input clk;
    input rst;
    input [4:0] height_in, width_in;

    output [3:0] str_id_1;
    output [3:0] str_id_2;
    output [3:0] str_id_3;
    output [7:0] occ_width_1;
    output [7:0] occ_width_2;
    output [7:0] occ_width_3;
    output [4:0] width_out;
    output [4:0] height_out;
    
    // Input sampling stage
    wire [4:0] height_input, width_input;

    P1_Reg_5_bit height_in_reg (.DataIn(height_in), .DataOut(height_input), .rst(rst), .clk(clk));
    P1_Reg_5_bit width_in_reg (.DataIn(width_in), .DataOut(width_input), .rst(rst), .clk(clk));
    
    // Find Row stage
    wire [4:0] row_stage_height, row_stage_width;
    wire [3:0] internal_str_id_1, internal_str_id_2, internal_str_id_3;

    Find_Row find_row_stage (.clk(clk), .height_in(height_input), .width_in(width_input), 
                             .str_id_1(internal_str_id_1), .str_id_2(internal_str_id_2), .str_id_3(internal_str_id_3));
    
    P1_Reg_5_bit find_row_height_reg(.DataIn(height_input), .DataOut(row_stage_height), .rst(rst), .clk(clk));
    P1_Reg_5_bit find_row_width_reg(.DataIn(width_input), .DataOut(row_stage_width), .rst(rst), .clk(clk)); 

    // Read reg arr stage
    wire [4:0] read_arr_stage_height, read_arr_stage_width;
    wire [3:0] strip_id_1, strip_id_2, strip_id_3;
    reg [7:0] occ_width_1_reg, occ_width_2_reg, occ_width_3_reg;
    reg [7:0] occupied_width [0:13];// DOUBLE CHECK
    
    // Assign output registers to module outputs
    assign occ_width_1 = occ_width_1_reg;
    assign occ_width_2 = occ_width_2_reg;
    assign occ_width_3 = occ_width_3_reg;
    assign str_id_1 = strip_id_1;
    assign str_id_2 = strip_id_2;
    assign str_id_3 = strip_id_3;

    always @(posedge clk)
    begin
        occupied_width[0] <= 8'd128;
        if (internal_str_id_1 != 0)
            occ_width_1_reg <= occupied_width[internal_str_id_1];
        if (internal_str_id_2 != 0)
            occ_width_2_reg <= occupied_width[internal_str_id_2];
        if (internal_str_id_3 != 0)
            occ_width_3_reg <= occupied_width[internal_str_id_3];
    end
   
    // Register connections to the outputs
    P1_Reg_5_bit read_arr_height_reg(.DataIn(row_stage_height), .DataOut(read_arr_stage_height), .rst(rst), .clk(clk));
    P1_Reg_5_bit read_arr_width_reg(.DataIn(row_stage_width), .DataOut(read_arr_stage_width), .rst(rst), .clk(clk));
    P1_Reg_4_bit read_arr_str_id_1_reg(.DataIn(internal_str_id_1), .DataOut(strip_id_1), .rst(rst), .clk(clk));
    P1_Reg_4_bit read_arr_str_id_2_reg(.DataIn(internal_str_id_2), .DataOut(strip_id_2), .rst(rst), .clk(clk));
    P1_Reg_4_bit read_arr_str_id_3_reg(.DataIn(internal_str_id_3), .DataOut(strip_id_3), .rst(rst), .clk(clk));

    assign width_out = read_arr_stage_width;
    assign height_out = read_arr_stage_height;

endmodule
