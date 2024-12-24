module Strike_Counter(
    strike_flag,
    clk,
    rst,

    strike_count
);
    
    input strike_flag;
    input clk;
    input rst; //high active

    output reg [3:0] strike_count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin 
            strike_count <= 0;
        end
        else if(strike_flag) begin
            strike_count <= strike_count + 1;
        end
    end

endmodule