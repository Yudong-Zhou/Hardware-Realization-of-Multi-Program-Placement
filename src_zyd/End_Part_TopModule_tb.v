//////////////////////////////////////////////////////////////////////////////////////
// function: testbench for end part topmdule of HRMPP :)
//
// author: Yudong Zhou
//
// Create time: 11/11/2024
//////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module End_Part_TopModule_tb ();
    // set up parameters
	parameter   HalfCycle		= 5;				//Half of the Clock Period is 5 ns
	localparam  Cycle		    = 2 * HalfCycle;	//The length of the entire Clock Period

    // set up input signals
    reg             clk;
    reg             rst;

    reg             strike_flag_write;
    reg [3 : 0]     strip_ID_write;
    reg [7 : 0]     old_occupied_width_write;
    reg [7 : 0]     new_occupied_width_write;
    reg [3 : 0]     strike_counter_write;
    
    // set up output signals
    wire [7 : 0]    index_x_output;
    wire [7 : 0]    index_y_output;
    wire [3 : 0]    strike_counter_output;

    // instantiate the module
    End_Part_TopModule End_Part_TopModule_inst (
        .clk                        (clk),
        .rst                        (rst),
        .strike_flag_write          (strike_flag_write),
        .strip_ID_write             (strip_ID_write),
        .old_occupied_width_write   (old_occupied_width_write),
        .new_occupied_width_write   (new_occupied_width_write),
        .strike_counter_write       (strike_counter_write),
        .index_x_output             (index_x_output),
        .index_y_output             (index_y_output),
        .strike_counter_output      (strike_counter_output)
    );

    // set up clock
    initial     clk = 0;
    always   #(HalfCycle)   clk = ~clk;

    // set up reset
    initial begin
            rst = 0;
        #1  rst = 1;
        #1  rst = 0;
    end

    // set up test
    initial begin
        #Cycle begin
            strike_flag_write           = 1;
            strip_ID_write              = 1;
            old_occupied_width_write    = 0;
            new_occupied_width_write    = 16;
            strike_counter_write        = 1;
            $display("index_x = %d, index_y = %d, strike_cnt = %d", index_x_output, index_y_output, strike_counter_output);
        end
        #Cycle begin
            strike_flag_write           = 0;
            strip_ID_write              = 5;
            old_occupied_width_write    = 21;
            new_occupied_width_write    = 27;
            strike_counter_write        = 2;
            $display("index_x = %d, index_y = %d, strike_cnt = %d", index_x_output, index_y_output, strike_counter_output);
        end
        #Cycle begin
            strike_flag_write           = 0;
            strip_ID_write              = 8;
            old_occupied_width_write    = 52;
            new_occupied_width_write    = 70;
            strike_counter_write        = 10;
            $display("index_x = %d, index_y = %d, strike_cnt = %d", index_x_output, index_y_output, strike_counter_output);
        end
    end

    // end simulation
    initial begin
        #(10*Cycle) $stop;
    end

endmodule