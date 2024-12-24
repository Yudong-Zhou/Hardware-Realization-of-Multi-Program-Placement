module Min_Occupied_Strip_Selector(
    strip_id_1,
    strip_id_2,
    strip_id_3,
    occupied_width_1,
    occupied_width_2,
    occupied_width_3,
    min_occupied_width_no,

    min_occupied_strip_id,
    min_occupied_strip_width
);

    input [3:0] strip_id_1;
    input [3:0] strip_id_2;
    input [3:0] strip_id_3;
    input [7:0] occupied_width_1;
    input [7:0] occupied_width_2;
    input [7:0] occupied_width_3;
    input [1:0] min_occupied_width_no;

    output reg [3:0] min_occupied_strip_id;
    output reg [7:0] min_occupied_strip_width;

    always @* begin
        case(min_occupied_width_no)
            2'd1: begin
                min_occupied_strip_id <= strip_id_1;
                min_occupied_strip_width <= occupied_width_1;
            end
            2'd2: begin
                min_occupied_strip_id <= strip_id_2;
                min_occupied_strip_width <= occupied_width_2;
            end
            2'd3: begin
                min_occupied_strip_id <= strip_id_3;
                min_occupied_strip_width <= occupied_width_3;
            end
            default:begin
                min_occupied_strip_id <= 0;
                min_occupied_strip_width <= 0;
            end
        endcase
    end

endmodule