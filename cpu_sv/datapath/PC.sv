module PC (
    input  logic        clk, rst,
    input  logic [31:0] npc,
    input  logic        stall,
    output logic [31:0] pc
);

    always_ff @(posedge clk) begin
        if (rst) begin
            pc <= '0;
        end else if (!stall) begin
            pc <= npc;
        end
        // else 保持原值
    end

endmodule