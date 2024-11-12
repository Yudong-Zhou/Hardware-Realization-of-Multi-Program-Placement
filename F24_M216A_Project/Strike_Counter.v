//not decided which stage to put
module Strike_Counter(
    strike_flag,
    clk,
    rst,

    strike_count
);
    
    input strike_flag;
    input clk;
    input rst; //high active

    output [3:0] strike_count;

    always @(posedge clk) begin
        if (rst) strike_count <= 0;
        else if (strike_flag) strike_count <= strike_count + 1;
    end

endmodule