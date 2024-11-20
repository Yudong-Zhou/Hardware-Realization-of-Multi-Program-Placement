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

    reg [1:0] flag_cache; // when flag_cache = 0, strike count + 1
    
    always @(posedge clk) begin
        if (rst) begin 
            strike_count <= 0;
            flag_cache <= 0;
        end
        else if(strike_flag) begin
            if (flag_cache == 2'b00) begin 
                strike_count <= strike_count + 1;
            end
            flag_cache <= flag_cache + 2'b01;
        end
    end

endmodule