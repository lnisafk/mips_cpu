module IFID(
    input  logic        clk, rst, stall, // flush
    input  logic [31:0] pc4_IF,
    input  logic [31:0] Instr_IF,
    output logic [31:0] pc4_ID,
    output logic [31:0] Instr_ID
);

    always_ff @(posedge clk) begin
        if (rst) begin
            Instr_ID <= '0;
            pc4_ID   <= '0;
        end else if (!stall) begin
            Instr_ID <= Instr_IF;
            pc4_ID   <= pc4_IF;
        end
        // else: hold value (stall)
    end
endmodule