//////////////////////////////////////////////////////////
// function: RAM, 3-read-port, 1-write-port
//
// author: Yudong Zhou
//
// Create time: 11/24/2024
//////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module ram #(
    parameter ADDR_WIDTH = 4,  // strip number = 13, need 4 bits to store
    parameter DATA_WIDTH = 8   
)(
    input                               clk,     
    input                               rst, 
    input                               write_en,
    input                               read_en,     
    input  [ADDR_WIDTH - 1 : 0]         addr_write, 
    input  [DATA_WIDTH - 1 : 0]         data_in,    

    input  [ADDR_WIDTH - 1 : 0]         addr_read1,   
    input  [ADDR_WIDTH - 1 : 0]         addr_read2, 
    input  [ADDR_WIDTH - 1 : 0]         addr_read3, 

    output reg [DATA_WIDTH - 1 : 0]     data_out1,
    output reg [DATA_WIDTH - 1 : 0]     data_out2, 
    output reg [DATA_WIDTH - 1 : 0]     data_out3  
);

    reg [DATA_WIDTH - 1 : 0]    ram [0 : 13];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ram[0]  <= 8'd128;
            ram[1]  <= 8'b0;
            ram[2]  <= 8'b0;
            ram[3]  <= 8'b0;
            ram[4]  <= 8'b0;
            ram[5]  <= 8'b0;
            ram[6]  <= 8'b0;
            ram[7]  <= 8'b0;
            ram[8]  <= 8'b0;
            ram[9]  <= 8'b0;
            ram[10] <= 8'b0;
            ram[11] <= 8'b0;
            ram[12] <= 8'b0;
            ram[13] <= 8'b0;
            data_out1 <= 8'b0;
            data_out2 <= 8'b0;
            data_out3 <= 8'b0;
        end
        else begin
            if (write_en && addr_write) begin
                ram[addr_write] <= data_in;
            end
            else if (read_en) begin
                data_out1 <= ram[addr_read1];
                data_out2 <= ram[addr_read2];
                data_out3 <= ram[addr_read3];
            end
        end
    end

endmodule
