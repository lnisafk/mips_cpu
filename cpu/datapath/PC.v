module PC (
    input clk, rst,
    input [31:0] npc,
    input stall,
    output reg [31:0] pc
);
    initial begin
        pc <= 0;
    end
    always @(posedge clk) begin
        if (rst)
            pc <= 0;
        else if (!stall) begin
            pc <= npc;
        end
    end
endmodule